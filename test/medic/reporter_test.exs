defmodule Medic.ReporterTest do
  use ExUnit.Case

  alias Medic.Reporter
  alias Medic.Report

  test "transmits the ping report" do
    report = %Report{check_id: 1, results: %{}}
    Reporter.handle_cast(report, [transport: Reporter.Inbox, dest: self])

    assert_receive ^report
  end
end
