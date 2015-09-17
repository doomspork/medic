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

Configuration can be supplied via command line options or through the application defaults, which are stored in `config/config.exs`:

```elixir
config :medic,
  ping_freq: (1000 * 60),
  report_url: "",
  update_url: "",
  update_freq: (1000 * 60 * 60),
  hosts: [],
  no_update: false
```

### Options

+ `--stdout` – Report pings through standard out
+ `--no-update` - Disable recurring updates to the host list
+ `--hosts "example.org,example.com"` - Seed the storage with hosts, given as a comma delimited string

## Building

	$ mix escript.build

## Example

	$ ./medic --no-update --stdout --hosts "127.0.0.1,example.com"
