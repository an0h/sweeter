# Sweeter

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

```
curl -X POST -d 'user[email]=sc@rib.e&user[password]=dapaSS!2' http://localhost:4000/api/v1/session  | jq -r '.[]["access_token"]'

curl -H "Authorization: fillout" http://localhost:4000/api/v1/get_items?query=#match
```