defmodule Medic do
  import Supervisor.Spec

  def main(args \\ []) do
    args
    |> parse_args
    |> combine_config
    |> supervise
    |> run
  end

  defp supervise(opts), do: opts |> config_children

  defp run(children) do
    Supervisor.start_link(children, strategy: :one_for_one)

    :timer.sleep(:infinity)
  end

  defp config_children(opts) do
    [
      supervisor(Task.Supervisor, [[name: :tasks_sup]]),
      worker(Medic.Checker, [[interval: opts[:check_freq]]]),
      worker(Medic.Reporter, [[dest: opts[:report_url]]]),
      worker(Medic.Storage, []),
      worker(Medic.Updater, [[interval: opts[:update_freq], dest: opts[:update_url]]])
    ]
  end

  defp combine_config(args) do
    :medic
    |> Application.get_all_env
    |> Keyword.merge(args)
  end

  defp parse_args(args) do
    {opts, _, _} = OptionParser.parse(args)
    opts
  end
end
