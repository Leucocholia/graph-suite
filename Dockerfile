FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates ghc python3 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/graph-suite
COPY app ./app

RUN useradd --create-home --shell /usr/sbin/nologin graphsuite
USER graphsuite

ENV GRAPH_SUITE_PORT=8080
ENV GRAPH_SUITE_COMPILE_TIMEOUT=20
ENV GRAPH_SUITE_RUN_TIMEOUT=20
ENV GRAPH_SUITE_MAX_OUTPUT_BYTES=4194304

EXPOSE 8080
CMD ["sh", "-c", "python3 app/graph_server.py --host 0.0.0.0 --port ${PORT:-8080}"]
