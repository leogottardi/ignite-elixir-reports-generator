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

  defp handle_report([name, hours, _day, month, year], %{
         all_hours: all_hours,
         hours_per_month: persons_month,
         hours_per_year: persons_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = handle_hours_per_month(persons_month, name, month, hours)
    hours_per_year = handle_hours_per_year(persons_year, name, year, hours)

    %{all_hours: all_hours, hours_per_month: hours_per_month, hours_per_year: hours_per_year}
  end

  defp handle_hours_per_year(persons, name, year, hours) do
      person = %{name => Map.put(persons[name], year, persons[name][year] + hours)}

      Map.merge(persons, person)
  end

  defp handle_hours_per_month(persons, name, month, hours) do
    person = %{name => Map.put(persons[name], month, persons[name][month] + hours)}

    Map.merge(persons, person)
  end

  def report_acc() do
    all_hours = Enum.into(@persons, %{}, &{&1, 0})
    hours_per_month = Enum.into(@persons, %{}, &{&1, months_per_person()})
    hours_per_year = Enum.into(@persons, %{}, &{&1, years_per_person()})

    %{all_hours: all_hours, hours_per_month: hours_per_month, hours_per_year: hours_per_year}
  end

  defp months_per_person(), do: Enum.into(@months, %{}, &{&1, 0})
  defp years_per_person(), do: Enum.into(@years, %{}, &{&1, 0})
end
