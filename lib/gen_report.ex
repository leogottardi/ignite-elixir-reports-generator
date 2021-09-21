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

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(result, report) end)
  end

  defp handle_report([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => persons_month,
         "hours_per_year" => persons_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = sum_hours(persons_month, name, month, hours)
    hours_per_year = sum_hours(persons_year, name, year, hours)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp sum_hours(persons, name, month, hours) do
    person = %{name => Map.put(persons[name], month, persons[name][month] + hours)}

    Map.merge(persons, person)
  end

  defp sum_reports(
         %{
           "all_hours" => all_hours1,
           "hours_per_month" => hours_per_month1,
           "hours_per_year" => hours_per_year1
         },
         %{
           "all_hours" => all_hours2,
           "hours_per_month" => hours_per_month2,
           "hours_per_year" => hours_per_year2
         }
       ) do
    all_hours = map_data(all_hours1, all_hours2)

    hours_per_month =
      Map.merge(hours_per_month1, hours_per_month2, fn _key, value1, value2 ->
        map_data(value1, value2)
      end)

    hours_per_year =
      Map.merge(hours_per_year1, hours_per_year2, fn _key, value1, value2 ->
        map_data(value1, value2)
      end)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp map_data(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp report_acc() do
    all_hours = Enum.into(@persons, %{}, &{&1, 0})
    hours_per_month = build_hours_per_data(@months)
    hours_per_year = build_hours_per_data(@years)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp build_hours_per_data(data), do: Enum.into(@persons, %{}, &{&1, build_per_data(data)})
  defp build_per_data(data), do: Enum.into(data, %{}, &{&1, 0})

  defp build_report(all_hours, hours_per_month, hours_per_year),
    do: %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
end
