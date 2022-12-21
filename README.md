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

## Example Usage

```bash
~ % kubectl apply -f ./MyManifest.yaml
pod/tools created
```

## Remote Shell In Container

```bash
~ % kubectl exec --stdin --tty -n default tools -- bash
root@tools:/#
```

## SSH config

This container runs sshd. By mapping port 22 to a load balancer / host you can ssh to the host.

You can map valid ssh keys to `/home/ubuntu/.ssh/authorized_keys`

The following files can be mapped.
```
/etc/ssh/ssh_config # sshd configuration file.
/etc/ssh/ssh_host_ed25519_key.pub # ed25519 host public key
/etc/ssh/ssh_host_ed25519_key # ed25519 host private key
/etc/ssh/ssh_host_rsa_key.pub # rsa host public key
/etc/ssh/ssh_host_rsa_key # rsa host private key
/etc/ssh/ssh_host_ecdsa_key.pub # ecdsa host public key
/etc/ssh/ssh_host_ecdsa_key # ecdsa private key

/etc/ssh/sshd_config
```

