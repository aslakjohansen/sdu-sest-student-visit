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
