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

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> handle_report(line, report) end)
  end

  defp handle_report([name, hours, _day, month, _year], %{
         all_hours: all_hours,
         hours_per_month: persons
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = handle_hours_per_month(persons, name, month, hours)

    %{all_hours: all_hours, hours_per_month: hours_per_month}
  end

  defp handle_hours_per_month(persons, name, month, hours) do
    person = %{name => Map.put(persons[name], month, persons[name][month] + hours)}

    Map.merge(persons, person)
  end

  def report_acc() do
    all_hours = Enum.into(@persons, %{}, &{&1, 0})
    hours_per_month = Enum.into(@persons, %{}, &{&1, months_per_person()})

    %{all_hours: all_hours, hours_per_month: hours_per_month}
  end

  defp months_per_person(), do: Enum.into(@months, %{}, &{&1, 0})
end
