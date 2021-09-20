defmodule GenReport do
  alias GenReport.Parser

  @persons [
    "daniele",
    "mayk",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "diego",
    "rafael",
    "vinicius",
    "danilo"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> handle_report(line, report) end)
  end

  defp handle_report([name, hours, _day, _month, _year], %{all_hours: all_hours}) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    %{all_hours: all_hours}
  end

  def report_acc() do
    all_hours = Enum.into(@persons, %{}, &{&1, 0})

    %{all_hours: all_hours}
  end
end
