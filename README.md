# tools
 Docker container for testing and troubleshooting.


## Build instructions 

On M1

```bash
docker buildx create --use
docker buildx build . --platform linux/amd64,linux/arm64 --tag alphabet5/tools --push
```


## K8s Manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: tools
  namespace: default
spec:
  containers:
  - name: tools
    image: alphabet5/tools
    imagePullPolicy: Always
```
