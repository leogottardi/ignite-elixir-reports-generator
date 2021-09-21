defmodule GenReport do
  alias GenReport.Parser

  @persons Data.build("persons")
  @months Data.build("months")
  @years Data.build("years")

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> handle_report(line, report) end)
  end

  def build(), do: {:error, "Insira o nome de um arquivo"}

  defp handle_report([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => persons_month,
         "hours_per_year" => persons_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = handle_sum_hours(persons_month, name, month, hours)
    hours_per_year = handle_sum_hours(persons_year, name, year, hours)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp handle_sum_hours(persons, name, month, hours) do
    person = %{name => Map.put(persons[name], month, persons[name][month] + hours)}

    Map.merge(persons, person)
  end

  def report_acc() do
    all_hours = Enum.into(@persons, %{}, &{&1, 0})
    hours_per_month = build_hours_per_data(@months)
    hours_per_year = build_hours_per_data(@years)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp build_hours_per_data(data), do: Enum.into(@persons, %{}, &{&1, build_per_data(data)})
  defp build_per_data(data), do: Enum.into(data, %{}, &{&1, 0})
end
