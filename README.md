# Sweeter

### DB Startup
`docker run --name postgres  -e POSTGRES_PASSWORD=c0f33isyummy  -p 5432:5432 -d --rm postgres`
`docker exec -it 5993373cff98 psql -U postgres`
`MIX_ENV=test mix ecto.reset`

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

https://hexdocs.pm/pow/api.html#content
https://abulasar.com/adding-infinite-scroll-in-phoenix-liveview-app
https://blog.differentpla.net/blog/2022/01/08/libcluster-kubernetes/
https://www.welcometothejungle.com/fr/articles/redis-mnesia-distributed-database
https://dev.to/alvaromontoro/create-a-tag-cloud-with-html-and-css-1e90
https://codepen.io/drehimself/pen/vpeVMx

```
curl -X POST -d 'user[email]=sc@rib.e&user[password]=dapaSS!2' http://localhost:4000/api/v1/session  | jq -r '.[]["access_token"]'

curl -H "Authorization: fillout" http://localhost:4000/api/v1/get_items?query=#match
```

    export api1317="http://0.0.0.0:1317"
    export faucet4500="http://0.0.0.0:4500"
    export assigner5555="http://0.0.0.0:5555"