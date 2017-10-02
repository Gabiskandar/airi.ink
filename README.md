# aether
A design and development project for airi.ink.

## Getting started (Docker)

To launch the app, you'll need to:

1. Clone `git@gitlab.com:gabiskandar/aether.git`.
2. Change directory (`cd`) to aether, and run command: `docker build -t aether .` to build in the current directory.
3. Run `docker run --name aether -p 80:8090 -d aether` to run the web application on the docker instance and route to port 80.
4. It will now be served up at [http://localhost](http://localhost).
5. To stop, run `docker stop aether`.
6. Use `make build` to rebuild (and clean) with new updates.
7. To serve, run `docker restart aether`.

## Deployment

Deployment is managed by Kubernetes. For local setup, please see the instructions [here](https://gitlab.com/gabsiskandar/aether/blob/master/docs/local-cluster.md).

Login to the Docker hub via [hub.docker.com]():

```
docker login
```

When prompted, enter the Docker username and password.

The login process creates or updates a `config.json` file that holds on authorization token.

View the `config.json` file:

```
cat ~/.docker/config.json
```

The output contains a section similar to this:

```
{
    "auths": {
        "hub.docker.com": {

        }
    },
    "credStore": "osxkeychain"
}
```

If the `credStore` value is populated, then your token is stored in a local credstore and not in
your local Docker settings. However, if the auths value is populated, then that's your token
instead.

### Azure

Before the setup, Azure admin should create a resource group and an application (with `Owner` scope in that resource group) and provide the application ID, key and the Tenant ID (which will be used by the CLI)

 - Install the Azure CLI.
 - Login into Azure using the application credentials `az login -u <app-id> -p <key> --service-principal --tenant <tenant-id>`
 - Create a new container service under the resource group.
 - Choose appropriate values (with kubernetes for orchestration, your public key for `ssh`, application ID and key for client name and secret, etc.)
 - Make sure that `kubectl` is configured with Azure app credentials (do so with `az acs kubernetes get-credentials --resource=group=<group-name> --name=<app-name>`

### Pods and Services

These deployment files are required for launching the cluster in a Kubernetes group.

 - `aether/deploy/proxy-service.yaml` - Aether Proxy Service
 - `aether/deploy/proxy-configmap.yaml` - Aether Proxy Configuration
 - `aether/deploy/proxy-deployment.yaml` - Aether Proxy Application ([Nginx](https://www.nginx.com/))
 - `aether/app/app-service.yaml` - Aether App Service
 - `aether/app/app-deployment.yaml` - Aether App Deployment

Before you deploy those, please make sure that the registry images have been updated with the latest versions of the containers, and the Kubernetes config YAML files have the right versions of the images.

The services should be launched in order.

Once you launch nginx (the final deployment), the service gets exposed to the outside world. In Azure, the IP address allocation takes 5-10 mins. You can check that by polling `kubectl get services` every few seconds.

### Notes

 - If you change something in the images or the configuration related to the containers (like bumping the image version in the container configuration of a deployment/statefulset, changing the configmap, or environment variables or persistent volume mounts, etc.), then the entire deployment/statefulset should be relaunched.
 - If you change something related to the services (like its name, the selector, or the internal cluster IP address), then the service should be relaunched.
 - Also make sure that you're not deleting any critical resources. For example, persistent volume claims (when deleted manually) cannot be reclaimed under the same name (at least, in Azure). Technologies like cockroach and vault depend on those volume claims. So, ensure that you've got backup of necessary data from those volumes before planning to upgrade them.

### Troubleshooting

You can use `kubectl describe <resource> <name>` to get more detailed information about a particular resource. For example, `kubectl describe deployment aether` shows listing of what's going on. This is useful if something goes wrong before the containers have started.

You can use `kubectl get <resource>` to get short information about the resources (`kubectl get pods` or `kubectl get services`, etc.). `kubectl logs <pod-name>` shows the logs of a pod (pods managed by deployments have strange names - you can get their names by checking `kubectl get pods`).
