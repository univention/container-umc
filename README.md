# Container for the Univention Management Console

## Local stack

`docker-compose.yaml` starts the UMC server with the UCR settings from `tests/stub_data/base.conf`
and the stub secrets beside it.

    docker compose up --detach umc-server

## Container for the Apache Gateway

This contains merely static files, such as javascript, stylesheets and images.
