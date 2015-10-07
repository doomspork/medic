defmodule Medic.ReporterTest do
  use ExUnit.Case

  alias Medic.Reporter
  alias Medic.Report

  test "transmits the ping report" do
    report = %Report{health_check_id: 1, successful: true, response_time: 52.0}
    Reporter.handle_cast(report, [transport: Reporter.Inbox, dest: self])

    assert_receive ^report
  end
end
