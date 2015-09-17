defmodule Medic do
  import Supervisor.Spec

  def main(args) do
    args
    |> parse_args
    |> combine_config
    |> supervise
    |> run
  end

  defp supervise(opts) do
    opts
    |> config_children
    |> config_updates
    |> config_reporting
  end

  defp run(children) do
    Supervisor.start_link(children, strategy: :one_for_one)

    :timer.sleep(:infinity)
  end

  defp config_children(opts) do
    children = [
      supervisor(Task.Supervisor, [[name: :tasks_sup]]),
      worker(Medic.Storage, [opts[:checks]]),
      worker(Medic.Checker, [[interval: opts[:check_freq]]]),
    ]

    {children, opts}
  end

  defp config_updates({children, opts}) do
    unless opts[:no_update] do
      args = [interval: opts[:update_freq], dest: opts[:update_url]]
      child = worker(Medic.Updater, [args])
      children = [child|children]
    end
    {children, opts}
  end

  defp config_reporting({children, opts}) do
    transport = cond do
      opts[:stdout] -> Medic.Reporter.StdOut
      true -> Medic.Reporter.JSON
    end
    child = worker(Medic.Reporter, [[dest: opts[:report_url], transport: transport]])
    children = [child|children]

    children
  end

  defp combine_config(args) do
    :medic
    |> Application.get_all_env
    |> Keyword.merge(args)
  end

  defp parse_args(args) do
    {opts, _, _} = OptionParser.parse(args)
    parse_checks(opts)
  end

  defp parse_checks(opts) do
    checks = [:get, :ping]
              |> Enum.map(fn (type) -> {type, opts[type]} end)
              |> Enum.flat_map(&(parse_check(&1)))
    Keyword.put(opts, :checks, checks)
  end

  defp parse_check({type, value}) do
    value
    |> String.split(",")
    |> Enum.map(&String.strip/1)
    |> Enum.map(fn (address) -> %Medic.Check{address: address, id: type, type: type} end)
  end
end
