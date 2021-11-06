# Gateway

Gateway, that periodically scans for attached serial ports that match a pattern, connects to them and and forwards any received line that is a valid JSON object with only numbers as values to a public MQTT broker.

## Installation

Install dependencies for [Circuits.UART](https://github.com/elixir-circuits/circuits_uart):
```shell
apt-get install build-essential erlang-dev
```

Then fetch and compile dependencies:
```shell
mix deps.get
mix compile
```

## Startup

Open an iex session using `iex -S mix` and run:
```elixir
GatewayApplication.start(nil, nil)
```

# Adding Support for Other Devices

First, determine what makes the device unique by executing `iex -S mix` and running:
```elixir
Circuits.UART.enumerate()
```

Then add a proper pattern match to `handle_info(:scan, state)` in [lib/scanner.ex](lib/scanner.ex).

