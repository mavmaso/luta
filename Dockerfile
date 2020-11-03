FROM elixir:latest

RUN apt-get update
RUN apt-get install -y postgresql-client

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force
RUN mix compile

CMD ["/app/entrypoint.sh"]
