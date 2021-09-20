defmodule Data do
  @data %{
    "persons" => [
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
    ],
    "months" => [
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
    ],
    "years" => [
      2016,
      2017,
      2018,
      2019,
      2020
    ]
  }

  def build(option), do: @data[option]
end
