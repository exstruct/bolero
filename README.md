# bolero

random data generator

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `bolero` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:bolero, "~> 0.1.0"}]
    end
    ```

  2. Ensure `bolero` is started before your application:

    ```elixir
    def application do
      [applications: [:bolero]]
    end
    ```

## Usage

In this example we'll generate a URI

```elixir
use Bolero

ascii = list(char_alpha, 1, 10)

scheme =
  ["http", "https", "ws", "wss"]
  |> pick()

host =
  [ascii, ".", list(char_alpha, 1, 4)]
  |> string_join()

port = int(0, 10_000)

path =
  ascii
  |> list(1, 5)
  |> bind(&("/" <> Enum.join(&1, "/")))

query =
  [ascii, "=", ascii]
  |> string_join()
  |> list(1, 5)
  |> bind(&Enum.join(&1, "&"))

generator =
  [scheme: scheme,
   host: host,
   port: port,
   path: path,
   query: oneof([query, nil])]
  |> map(%URI{})
  |> bind(&to_string/1)
```

We can now call `generate/1` for as many URI structs as we need:

```elixir
generator |> generate()
# "https://XBYdwIG.R:4502"
generator |> generate()
# "http://jnOIOevE.CQjX:9247/iB/bP/LVDumxzFWM?gjD=oFaKzUQuS&Ujjdpu=CvypfruKB&HazmOb=b&FEWskVjF=m&OMegDnbb=yzcKQ"
```
