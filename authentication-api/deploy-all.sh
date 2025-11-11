docker stack deploy --compose-file authentication-api/dependencies-stack.yml authentication_dependencies

sleep 10

docker stack deploy --compose-file authentication-api/stack.yml authentication