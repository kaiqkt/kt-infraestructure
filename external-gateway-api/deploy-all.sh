docker stack deploy --compose-file external-gateway-api/dependencies-stack.yml gateway_dependencies

sleep 10

docker stack deploy --compose-file external-gateway-api/stack.yml gateway