defmodule Vannotate do
  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts("No arguments given")
  end

  def process(options) do
    IO.puts("Getting descriptions...")

    lines = source_lines(options[:source])

    output = annotated_lines(lines)
              |> Enum.join("\n")

    File.write("./tmp/output.vim", output)

    IO.puts("Finished!")
  end

  defp annotated_lines(lines) do
    Enum.map(lines, fn (line) ->
      case plug_line?(line) do
        true -> annotated_line(line)
        _    -> line
      end
    end)
  end

  defp annotated_line(line) do
    description = repo_description(repo_name(line))

    case description do
      nil -> line
      ""  -> line
      _   ->
        escaped_description = String.replace(description, "\"", "\\\"")
        annotation = " \" #{escaped_description}"
        line_parts = String.split(line, "\"")

        case length(line_parts) do
          1 -> line <> annotation
          2 -> String.strip(Enum.at(line_parts, 0)) <> annotation
          _ -> line # TODO: handle more than 1 quote
        end
    end
  end

  defp repo_name(line) do
    captures = Regex.run(~r/(?<=')(?:\\.|[^'\\])*(?=')/, line)
    Enum.at(captures, 0)
  end

  defp plug_line?(line) do
    String.starts_with?(String.strip(line), "Plug")
  end

  defp repo_description(repo_name) do
    result = scrape_website(repo_name)
    case result do
      nil     -> nil
      website -> Enum.at(String.split(website.description, "- "), 1)
    end
  end

  defp scrape_website(repo_name) do
    url = "https://github.com/#{repo_name}"
    Scrape.website(url)
  end

  defp source_content(source) do
    {:ok, content} = File.read(source)
    content
  end

  defp source_lines(source) do
    String.split(source_content(source), "\n")
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [source: :string]
    )
    options
  end
end
