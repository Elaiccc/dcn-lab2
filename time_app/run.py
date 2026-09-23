# Ziyi Liu - DCN Lab 2
# Adapted from metacomp/nyu-cs2262-001-fa20/sample_time_app (MIT).
from datetime import datetime, timezone

from flask import Flask, make_response

app = Flask(__name__)


@app.get("/")
def hello_world():
    return '<!doctype html><html><head><title>Time app</title></head><body><h1>Hello world!</h1><p><a href="/time">Current time</a></p></body></html>\n'


@app.get("/time")
def current_time():
    now = datetime.now(timezone.utc).isoformat(timespec="milliseconds")
    response = make_response(
        '<!doctype html>\n<html lang="en">\n<head><meta charset="utf-8">'
        '<title>Current time</title></head>\n<body>\n'
        '<h1>Current time UTC</h1>\n'
        f'<p id="current-time">{now}</p>\n'
        '<p>Ziyi Liu - DCN Lab 2</p>\n</body>\n</html>\n'
    )
    response.headers["Cache-Control"] = "no-store"
    return response


@app.get("/healthz")
def health():
    return "ok\n", 200, {"Content-Type": "text/plain; charset=utf-8"}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=False)
