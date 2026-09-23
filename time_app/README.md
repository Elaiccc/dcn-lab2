# Lab 2 Time Application

Author: Ziyi Liu

This Flask application extends the instructor's sample with `GET /time`, which returns an HTML page containing the current UTC time. It computes the time for every request and sends `Cache-Control: no-store`. The root route retains the sample's greeting; `/healthz` supports Kubernetes probes.

## Run with Docker

From this `time_app` directory:

```bash
docker build -t sample-time-app:local .
docker run --name sample-time-app -p 127.0.0.1:8080:8080 sample-time-app:local
```

Visit `http://127.0.0.1:8080/time`. Gunicorn serves Flask on container port 8080. The Dockerfile uses Python 3.12 and an unprivileged user. Its only application dependencies are `run.py` and `requirements.txt`.

## Publish to Docker Hub

Replace `YOUR_DOCKERHUB_USERNAME` with your own username. Use a public lab image repository, or configure the appropriate pull credentials in Kubernetes.

```bash
docker login
docker buildx build --platform linux/amd64,linux/arm64 -t YOUR_DOCKERHUB_USERNAME/sample-time-app:latest --push .
```

If the current builder cannot build multiple architectures, use the provided `02_push_image.sh` in the Mac kit. It creates a dedicated builder.

## Kubernetes

Replace `DOCKERHUB_USERNAME` in `k8s/deployment.yaml`, create namespace `dcn-lab2`, and apply both manifests to your selected lab context. The Deployment uses one replica and port 8080. The Service is a NodePort with an automatically assigned node port.

The Mac kit's `03_deploy_minikube.sh` completes these steps in a dedicated Minikube profile. On macOS with the Docker driver, keep `minikube service ... --url` running and append `/time` to the returned address. The tunnel URL is distinct from the node's IP and NodePort.

For an existing cloud lab cluster, run `bash deploy_cloud.sh YOUR_DOCKERHUB_USERNAME YOUR_CONTEXT`. This script does not provision a cloud cluster. Capture the real deployment result and access method for the report.

## Submission

Keep this folder named `time_app` in your GitHub repository. Include its URL in `DCN-ziyi_liu_lab_2.docx`. Screenshots and captures belong in the report/evidence, not in the container image.

## References

- Instructor sample: https://github.com/metacomp/nyu-cs2262-001-fa20/tree/master/sample_time_app
- Docker Mac setup: https://docs.docker.com/desktop/setup/install/mac-install/
- Docker architectures: https://docs.docker.com/build/building/multi-platform/
- Minikube access: https://minikube.sigs.k8s.io/docs/handbook/accessing/
- Kubernetes Services: https://kubernetes.io/docs/concepts/services-networking/service/

See `SOURCE.md` and the original MIT license for attribution.
