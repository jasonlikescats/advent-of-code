Mix.install([:unicode])

defmodule Parser do
  def is_num(codepoint) do
    Unicode.category(codepoint) == [:Nd]
  end

  def parse_num(line) do
    codepoints = String.codepoints(line)

    first = Enum.find(codepoints, &is_num/1)
    last = Enum.reverse(codepoints) |> Enum.find(&is_num/1)

    Integer.parse(first <> last)
  end

  def parse_int(line) do
    {int, _} = parse_num(line)
    int
  end
end

result =
  File.stream!("input")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&Parser.parse_int/1)
  |> Enum.sum()

IO.puts(result)
