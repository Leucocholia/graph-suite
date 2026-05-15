# Deployment Notes

Graph Suite can be hosted two ways:

1. Static viewer only: deploy `app/` to a static host such as Cloudflare Pages or Netlify.
2. Public compiler: deploy the Docker service in this repo so `/compile-haskell` can run GHC.

The public compiler path should be treated as a backend service, not a static site.

## Docker Service

Build locally:

```powershell
docker build -t graph-suite .
```

Run locally:

```powershell
docker run --rm -p 8080:8080 graph-suite
```

Then open:

```text
http://127.0.0.1:8080/
```

## Production Settings

The container defaults to conservative limits:

```text
GRAPH_SUITE_COMPILE_TIMEOUT=20
GRAPH_SUITE_RUN_TIMEOUT=20
GRAPH_SUITE_MAX_OUTPUT_BYTES=4194304
```

Tune these on your host if larger examples need to compile publicly.

## Security Model

The compile endpoint now returns generated frame text directly to the browser instead of replacing `app/frames.jsonl`. This avoids shared global output between users.

User modules are compiled with:

```text
-XSafe -hide-all-packages -package base
```

The server runs a wrapper that calls the submitted module's pure `graphs :: Int -> [Graph]` function. It rejects `Main` modules so user-submitted `main` actions are not executed.

Safe Haskell is a guardrail, not the whole sandbox. For a public deployment, also configure the hosting platform/container runtime with:

- no privileged container mode
- a non-root user
- CPU and memory limits
- no mounted secrets
- no writable project directory
- network egress disabled for the compile container if your host supports it
