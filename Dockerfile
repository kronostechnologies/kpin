FROM --platform=$BUILDPLATFORM python:3.9-slim AS builder

COPY . /kpin/
RUN --mount=type=cache,target=/root/.cache/pip pip3 install -r /kpin/requirements.txt

FROM python:3.9-slim

COPY --from=builder /kpin/ /kpin/
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/

ENTRYPOINT ["/kpin/kpin"]
