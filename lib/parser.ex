defmodule GenReport.Parser do
  @months %{
    1 => "janeiro",
    2 => "fevereiro",
    3 => "março",
    4 => "abril",
    5 => "maio",
    6 => "junho",
    7 => "julho",
    8 => "agosto",
    9 => "setembro",
    10 => "outubro",
    11 => "novembro",
    12 => "dezembro"
  }

  def parse_file(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&format_values/1)
    |> List.update_at(3, &@months[&1])
  end

  defp format_values(string) do
    case Integer.parse(string) do
      {integer, _rest} -> integer
      :error -> String.downcase(string)
    end
  end
end
