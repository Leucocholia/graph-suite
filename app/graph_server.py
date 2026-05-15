from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import argparse
import json
import os
import shutil
import signal
import subprocess
import tempfile
import threading
import re


APP_DIR = Path(__file__).resolve().parent
PROJECT_DIR = APP_DIR.parent
MAX_SOURCE_BYTES = 512 * 1024
COMPILE_TIMEOUT_SECONDS = int(os.environ.get("GRAPH_SUITE_COMPILE_TIMEOUT", "45"))
RUN_TIMEOUT_SECONDS = int(os.environ.get("GRAPH_SUITE_RUN_TIMEOUT", "90"))
MAX_OUTPUT_BYTES = int(os.environ.get("GRAPH_SUITE_MAX_OUTPUT_BYTES", str(16 * 1024 * 1024)))
SAFE_GHC_FLAGS = ["-hide-all-packages", "-package", "base", "-XSafe"]


class ProcessTimeout(Exception):
    def __init__(self, timeout, stdout="", stderr=""):
        super().__init__(f"Process timed out after {timeout} seconds.")
        self.timeout = timeout
        self.stdout = stdout or ""
        self.stderr = stderr or ""


class GraphSuiteHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(APP_DIR), **kwargs)

    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "content-type")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(204)
        self.end_headers()

    def do_POST(self):
        if self.path != "/compile-haskell":
            self.send_error(404, "Unknown endpoint")
            return

        length = int(self.headers.get("content-length", "0"))
        if length <= 0 or length > MAX_SOURCE_BYTES:
            self.write_json(
                413,
                {
                    "ok": False,
                    "error": "Haskell source is empty or too large.",
                },
            )
            return

        try:
            payload = json.loads(self.rfile.read(length).decode("utf-8"))
            source = payload["source"]
            module_name = payload.get("module", "Main")
            vertex_count = int(payload.get("vertices", 6))
            if not isinstance(source, str) or not source.strip():
                raise ValueError("source must be a non-empty string")
            if not isinstance(module_name, str) or not re.match(r"^[A-Z][A-Za-z0-9_]*(\.[A-Z][A-Za-z0-9_]*)*$", module_name):
                raise ValueError("module must be a valid Haskell module name")
            if module_name == "Main":
                raise ValueError("the public compiler runs exported graphs functions; use a named module instead of Main")
            if vertex_count < 0:
                raise ValueError("vertices must be a non-negative integer")
        except Exception as exc:
            self.write_json(400, {"ok": False, "error": f"Bad request: {exc}"})
            return

        try:
            payload = compile_and_run(source, module_name, vertex_count)
        except Exception as exc:
            payload = {
                "ok": False,
                "error": "The compile server hit an internal error, but it is still running.",
                "output": str(exc),
            }

        self.write_json(200, payload)

    def write_json(self, status, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


def terminate_process_tree(process):
    if process.poll() is not None:
        return

    if os.name == "nt":
        try:
            subprocess.run(
                ["taskkill", "/F", "/T", "/PID", str(process.pid)],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                check=False,
                timeout=5,
            )
        except subprocess.TimeoutExpired:
            pass
    else:
        try:
            os.killpg(process.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass

    if process.poll() is None:
        try:
            process.kill()
        except OSError:
            pass
    try:
        process.wait(timeout=2)
    except (OSError, subprocess.TimeoutExpired):
        pass


def finish_timed_out_process(process):
    try:
        process.kill()
    except OSError:
        pass
    return "", "The process was stopped after exceeding the timeout."


def run_process(command, timeout, env=None):
    popen_args = {
        "cwd": PROJECT_DIR,
        "stdout": subprocess.PIPE,
        "stderr": subprocess.PIPE,
        "text": True,
        "env": env,
    }
    if os.name == "nt":
        popen_args["creationflags"] = subprocess.CREATE_NEW_PROCESS_GROUP
    else:
        popen_args["start_new_session"] = True

    process = subprocess.Popen(command, **popen_args)
    try:
        stdout, stderr = process.communicate(timeout=timeout)
    except subprocess.TimeoutExpired as exc:
        terminate_process_tree(process)
        stdout, stderr = finish_timed_out_process(process)
        raise ProcessTimeout(
            timeout,
            stdout or exc.stdout or "",
            stderr or exc.stderr or "",
        ) from exc

    return process.returncode, stdout, stderr


def make_temp_dir_path():
    return tempfile.mkdtemp(prefix="graph-suite-")


def cleanup_temp_dir(temp_dir):
    shutil.rmtree(temp_dir, ignore_errors=True)


def cleanup_temp_dir_later(temp_dir):
    threading.Thread(target=cleanup_temp_dir, args=(temp_dir,), daemon=True).start()


def timed_out_payload(stage, exc):
    output = exc.stdout + exc.stderr
    return {
        "ok": False,
        "error": (
            f"{stage} timed out after {exc.timeout} seconds. "
            "The server killed the runaway process and is still running. "
            "Try a smaller vertex count or a less expensive preset."
        ),
        "output": output,
    }


def source_path_for_module(temp_dir, module_name):
    return Path(temp_dir, *module_name.split(".")).with_suffix(".hs")


def runner_source(module_name, vertex_count):
    return "\n".join(
        [
            "module Main where",
            "",
            "import GraphRenderer (render)",
            "import qualified " + module_name + " as Program",
            "",
            "main :: IO ()",
            "main = render (Program.graphs " + str(vertex_count) + ")",
            "",
        ]
    )


def compile_and_run(source, module_name, vertex_count=6):
    if module_name == "Main":
        return {
            "ok": False,
            "error": "The public compiler runs exported graphs functions; use a named module instead of Main.",
        }

    ghc = shutil.which("ghc")
    if not ghc:
        return {
            "ok": False,
            "error": "Could not find ghc on PATH.",
        }

    temp_dir = make_temp_dir_path()
    cleanup_now = True
    try:
        source_path = source_path_for_module(temp_dir, module_name)
        source_path.parent.mkdir(parents=True, exist_ok=True)
        source_path.write_text(source, encoding="utf-8")
        runner_path = Path(temp_dir) / "Runner.hs"
        runner_path.write_text(runner_source(module_name, vertex_count), encoding="utf-8")
        build_dir = Path(temp_dir) / "build"
        build_dir.mkdir()
        runner_binary = Path(temp_dir) / ("graph-suite-runner.exe" if os.name == "nt" else "graph-suite-runner")

        try:
            code, stdout, stderr = run_process(
                [
                    ghc,
                    *SAFE_GHC_FLAGS,
                    "-i" + temp_dir,
                    "-iapp",
                    "-outputdir",
                    str(build_dir),
                    "-odir",
                    str(build_dir),
                    "-hidir",
                    str(build_dir),
                    "-o",
                    str(runner_binary),
                    str(runner_path),
                ],
                timeout=COMPILE_TIMEOUT_SECONDS,
            )
        except ProcessTimeout as exc:
            cleanup_now = False
            cleanup_temp_dir_later(temp_dir)
            return timed_out_payload("Compile", exc)

        if code != 0:
            return {
                "ok": False,
                "error": "Compile failed.",
                "output": stdout + stderr,
            }

        try:
            run_env = dict(os.environ)
            run_env["GRAPH_SUITE_FRAMES_PATH"] = "-"
            code, stdout, stderr = run_process(
                [str(runner_binary)],
                timeout=RUN_TIMEOUT_SECONDS,
                env=run_env,
            )
        except ProcessTimeout as exc:
            cleanup_now = False
            cleanup_temp_dir_later(temp_dir)
            return timed_out_payload("Run", exc)

        output = stdout + stderr
        if code != 0:
            return {"ok": False, "error": "Run failed.", "output": output}

        output_size = len(stdout.encode("utf-8"))
        if output_size > MAX_OUTPUT_BYTES:
            return {
                "ok": False,
                "error": (
                    "Run produced too much frame text. "
                    f"The limit is {MAX_OUTPUT_BYTES} bytes."
                ),
                "output": stderr,
            }

        validation_error, frame_count = validate_frames_text(stdout)
        if validation_error:
            return {
                "ok": False,
                "error": validation_error,
                "output": stderr,
            }

        return {
            "ok": True,
            "output": format_run_output(stderr, frame_count, output_size),
            "framesText": stdout,
        }
    finally:
        if cleanup_now:
            cleanup_temp_dir(temp_dir)


def validate_frames_text(text):
    frame_count = 0
    for line_number, line in enumerate(text.splitlines(), start=1):
        if not line.strip():
            continue
        try:
            frame = json.loads(line)
        except json.JSONDecodeError as exc:
            return f"Run produced invalid frame JSON on line {line_number}: {exc}", frame_count

        if not isinstance(frame, dict):
            return f"Run produced a non-object frame on line {line_number}.", frame_count
        if not isinstance(frame.get("i"), int):
            return f"Run produced a frame without an integer i field on line {line_number}.", frame_count
        if not isinstance(frame.get("v"), list) or not isinstance(frame.get("e"), list):
            return f"Run produced a frame without v/e lists on line {line_number}.", frame_count
        frame_count += 1

    if frame_count == 0:
        return "Run finished, but no frame text was written.", frame_count

    return None, frame_count


def format_run_output(stderr, frame_count, output_size):
    summary = f"Generated {frame_count} frame(s), {output_size} byte(s) of frame text."
    if stderr.strip():
        return summary + "\n\n" + stderr
    return summary


def main():
    parser = argparse.ArgumentParser(description="Graph Suite local compile server")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=int(os.environ.get("GRAPH_SUITE_PORT", "8012")))
    args = parser.parse_args()

    server = ThreadingHTTPServer((args.host, args.port), GraphSuiteHandler)
    print(f"Serving Graph Suite at http://{args.host}:{args.port}/")
    print("POST /compile-haskell compiles and runs submitted Haskell source.")
    print(
        "Timeouts: compile "
        + str(COMPILE_TIMEOUT_SECONDS)
        + "s, run "
        + str(RUN_TIMEOUT_SECONDS)
        + "s."
    )
    server.serve_forever()


if __name__ == "__main__":
    main()
