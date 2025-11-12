# KT Infrastructure

This repository holds the infrastructure configurations for KT projects, managed with Docker Swarm.

## Directory Structure

The repository is organized as follows:

-   `dependencies/`: This directory contains the configurations for all shared services, such as databases (e.g., PostgreSQL, Redis), message brokers, and other essential infrastructure components. Each service or stack of services should have its own `yml` file.

-   `authentication-api/`, `other-application/`: Each of these directories represents a separate application or microservice. They contain the specific Docker Compose files (`stack.yml`) for deploying that application.

## Getting Started

### Prerequisites

-   Docker installed and running.
-   Docker Swarm initialized.

### Deploying a Stack

To deploy a new stack, whether it's a dependency or an application, use the following command:

```bash
docker stack deploy --compose-file <path-to-your-compose-file.yml> <stack_name>
```

For example, to deploy the dependencies stack:

```bash
docker stack deploy --compose-file dependencies/dependencies-stack.yml dependencies
```

## Useful Commands

Here are some useful commands for managing your Docker Swarm services.

### Service Management

**Verify services status:**
```bash
docker service ls
```

**Scale a service:**
```bash
docker service scale <service_name>=<replicas>
```
*Example:*
```bash
docker service scale my_service=3
```

**Rollback a service:**
```bash
docker service rollback <service_name>
```

### Update a service

To update a service, you typically update its image or configuration and then redeploy the stack.

**Update a service image:**
```bash
docker service update --image <new_image_name> <service_name>
```
*Example:*
```bash
docker service update --image my_app:2.0 my_app_service
```

**Update a service with a new compose file:**
If you've made changes to your `stack.yml` (e.g., environment variables, ports, replicas), you can redeploy the stack to apply the updates.

```bash
docker stack deploy --compose-file <path-to-your-compose-file.yml> <stack_name>
```
*Example:*
```bash
docker stack deploy --compose-file authentication-api/stack.yml authentication-api
```

**View service logs:**
```bash
docker service logs <service_name>
```

### Docker Configs

**Create a config:**
```bash
docker config create <config_name> <path-to-config-file>
```
*Example:*
```bash
docker config create my_config ./config.json
```

**Updating a config:**

Simply changing the source file of a config is not enough to trigger a service update. The recommended way to update a config is to create a new, versioned config and update the service to use it.

1.  **Create a new version of the config:**
    ```bash
    docker config create <config_name>_v2 <path-to-new-config-file>
    ```
    *Example:*
    ```bash
    docker config create my_config_v2 ./new_config.json
    ```

2.  **Update your `stack.yml` to reference the new config:**
    ```yaml
    services:
      myapp:
        image: my_app_image
        configs:
          - source: my_config_v2
            target: /app/config.json
    
    configs:
      my_config_v2:
        external: true
    ```

3.  **Redeploy the stack:**
    This will perform a rolling update of the service to use the new config.
    ```bash
    docker stack deploy --compose-file <path-to-your-compose-file.yml> <stack_name>
    ```

4.  **(Optional) Remove the old config:**
    Once you have verified that the update was successful, you can remove the old config.
    ```bash
    docker config rm <config_name>
    ```

### Docker Secrets

**Create a secret from a file:**
```bash
docker secret create <secret_name> <path-to-secret-file>
```

**Create a secret from stdin:**
```bash
printf "This is a secret" | docker secret create my_secret_data -
```

**View secrets:**
```bash
docker secret ls
```

**Accessing a secret within a container:**
Secrets are mounted inside the container at `/run/secrets/<secret_name>`. You can use this path to expose the secret to your application, for example, by setting an environment variable.

*Example in a `docker-compose.yml`:*
```yaml
services:
  myapp:
    image: my_app_image
    secrets:
      - db_password
    environment:
      DB_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    external: true
```

## Observability

For more detailed observability, refer to the official Docker documentation on logging and monitoring. The `docker service logs` command is a good starting point for basic troubleshooting.

For more advanced topics, see the [Docker Compose file reference](https://docs.docker.com/reference/compose-file/deploy/#resources).
