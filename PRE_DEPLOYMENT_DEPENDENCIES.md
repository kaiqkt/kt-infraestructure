# Pre-Deployment Dependencies

Before deploying any services in this Docker Swarm environment, the following secrets must be created in your Docker Swarm environment. These secrets are marked as `external: true` in the `stack.yml` files, meaning Docker Swarm expects them to exist prior to service deployment.

## Required Secrets

Please create the following secrets using the `docker secret create` command:

-   **`authentication-database-password`**: Used by the `authentication-api` service for database access.
    ```bash
    printf "your_authentication_db_password" | docker secret create authentication-database-password -
    ```

-   **`access_token_secret`**: Used by the `authentication-api` service for JWT token signing.
    ```bash
    printf "your_access_token_secret" | docker secret create access_token_secret -
    ```

-   **`gateway-redis-password`**: Used by the `external-gateway-api` service for Redis access.
    ```bash
    printf "your_gateway_redis_password" | docker secret create gateway-redis-password -
    ```

-   **`grafana_admin_user`**: Used by the `grafana` service for the admin username.
    ```bash
    printf "your_grafana_admin_username" | docker secret create grafana_admin_user -
    ```

-   **`grafana_admin_password`**: Used by the `grafana` service for the admin password.
    ```bash
    printf "your_grafana_admin_password" | docker secret create grafana_admin_password -
    ```

## How to Create Secrets

You can create these secrets using the `docker secret create` command. For example:

```bash
printf "your_secret_value" | docker secret create <secret_name> -
```

**Important:** Replace `"your_secret_value"` with the actual secret content you wish to use. Ensure these secrets are created in the Docker Swarm environment where you plan to deploy the services.