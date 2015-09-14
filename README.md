# Pingbot

Pingbots maintain a list of addresses and report their ping status on a recurring basis.

## Setup

	$ git clone git@github.com:doomspork/beholder.git
	$ cd beholder
	$ mix deps.get

## Testing

	$ mix test

## Configuration

Update `config/config.exs` with the address to your mothership instance:

```elixir
config :pingbot, :mothership, "example.org"
```
  
## Running

	$ mix run --no-halt
