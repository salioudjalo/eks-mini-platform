import os
import socket
import time
from fastapi import FastAPI
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from starlette.responses import Response

app = FastAPI(title="eks-mini-platform")

START_TIME = time.time()
HOSTNAME = socket.gethostname()

REQ_COUNT = Counter("http_requests_total", "Total HTTP requests", ["path"])

@app.get("/")
def root():
    REQ_COUNT.labels(path="/").inc()
    return {
        "service": "eks-mini-platform",
        "version": os.getenv("APP_VERSION", "dev"),
        "hostname": HOSTNAME,
        "uptime_seconds": int(time.time() - START_TIME),
    }

@app.get("/healthz")
def healthz():
    REQ_COUNT.labels(path="/healthz").inc()
    return {"status": "ok"}

@app.get("/readyz")
def readyz():
    REQ_COUNT.labels(path="/readyz").inc()
    return {"status": "ready"}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)