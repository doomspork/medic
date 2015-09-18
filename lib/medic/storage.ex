defmodule Medic.Storage do
  @moduledoc """
  Simple storage for our current list of health checks.
  """

  def list do
    Agent.get(__MODULE__, &(&1))
  end

  def start_link(initial_state \\ []) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def stop, do: Agent.stop(__MODULE__)

  def update(list), do: Agent.update(__MODULE__, fn _data -> list end)
end
