# Source and Changes

Author: Ziyi Liu

Based on the instructor-provided `sample_time_app` in:
https://github.com/metacomp/nyu-cs2262-001-fa20

Source commit inspected during preparation: `9006d5042ea6bda9c7a654c1d9f6554bbb76dbc6`.

The original application defines only `/` and returns `Hello world!`. Its Dockerfile uses Python 3.5 and starts Flask with debugging enabled.

Changes for this lab:

- Added `/time` with a freshly computed UTC timestamp in HTML.
- Added `Cache-Control: no-store` and a `/healthz` endpoint.
- Updated the image to Python 3.12, pinned Flask and Gunicorn, and disabled debug mode.
- Used Gunicorn with two threads and a 10-second keep-alive timeout.
- Added a Deployment and NodePort Service.

The original MIT license is retained in `LICENSE`. Packet captures, screenshots, cloud results, and published repository links must come from the actual experiment; they are not supplied by this code.
