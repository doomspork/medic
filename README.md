# Pingbot

Pingbots maintain a list of addresses and report their ping status on a recurring basis.

## Setup

	$ git clone git@github.com:doomspork/beholder.git
	$ cd beholder
	$ mix deps.get

## Testing

	$ mix test

## Configuration

Configuration can be supplied via command line options or through the application defaults, which are stored in `config/config.exs`:

```elixir
config :pingbot,
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

	$ ./pingbot --no-update --stdout --hosts "127.0.0.1,example.com"
