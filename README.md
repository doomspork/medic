# Medic

Medic is an daemon for recurring healthchecks on remote hosts.

## Requirements

  + Erlang 18
  + Elixir 1.0

## Setup

	$ git clone git@github.com:doomspork/medic.git
	$ cd medic
	$ mix deps.get

## Testing

	$ mix test

## Configuration

Configuration are supplied through command line options or application configuration, which is stored in `config/config.exs`:

```elixir
config :medic,
  check_freq: (1000 * 60),
  checks: [],
  no_update: false,
  report_url: "",
  update_freq: (1000 * 60 * 60),
  update_url: ""
```

### Options

+ `--stdout` – Report pings through standard out
+ `--no-update` - Disable recurring updates to the host list
+ `--ping "example.org,example.com"` - Add `ping` health checks.
+ `--get "example.org,example.com"` - Add HTTP GET health checks.

_Note_: When supplied through the command line the `%Check{}` id is set to the check type.

## Building

	$ mix escript.build

## Example

	$ ./medic --no-update --stdout --get "seancallan.com,cityleash.com" --ping "127.0.0.1"
