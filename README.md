# Medic

Medic is an daemon for recurring healthchecks on remote hosts.

## Requirements

  + Erlang 18
  + Elixir 1.1

## Setup

	$ git clone git@github.com:doomspork/medic.git
	$ cd medic
	$ mix deps.get

## Testing

	$ mix test

## Configuration

Configuration supplied through command line overrides the application configuration stored in `config/config.exs`:

```elixir
config :medic,
  auth_token: "",
  check_freq: (1000 * 60),
  report_url: "",
  update_freq: (1000 * 60 * 60),
  update_url: ""
```

## Building

	$ mix escript.build

## Example

	$ ./medic --auth-token="areallylongtoken"
