# Pingbot

Pingbots maintain a list of addresses and report their ping status on a recurring basis.

## Setup

	$ git clone git@github.com:doomspork/beholder.git
	$ cd beholder
	$ mix deps.get

## Testing

	$ mix test

## Configuration

Update `config/config.exs` with your report and update URLs:

```elixir
config :pingbot,
  report_url: "",
  update_url: "",
  update_freq: 3200000
```

## Running

	$ mix run --no-halt
