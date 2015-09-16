defmodule Pingbot do
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
      worker(Pingbot.Storage, [opts[:hosts]]),
      worker(Pingbot.Checker, [[interval: opts[:ping_freq]]]),
    ]

    {children, opts}
  end

  defp config_updates({children, opts}) do
    unless opts[:no_update] do
      args = [interval: opts[:update_freq], dest: opts[:update_url]]
      child = worker(Pingbot.Updater, [args])
      children = [child|children]
    end
    {children, opts}
  end

  defp config_reporting({children, opts}) do
    transport = cond do
      opts[:stdout] -> Pingbot.Reporter.StdOut
      true -> Pingbot.Reporter.JSON
    end
    child = worker(Pingbot.Reporter, [[dest: opts[:report_url], transport: transport]])
    children = [child|children]

    children
  end

  defp combine_config(args) do
    :pingbot
    |> Application.get_all_env
    |> Keyword.merge(args)
  end

  defp parse_args(args) do
    {opts, _, _} = OptionParser.parse(args)

    hosts = cond do
      opts[:hosts] ->
        opts[:hosts]
        |> String.split(",")
        |> Enum.map(&String.strip/1)
      true -> []
    end

    Keyword.put(opts, :hosts, hosts)
  end
end
