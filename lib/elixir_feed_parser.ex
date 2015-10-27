defmodule ElixirFeedParser do
  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.Parsers.RSS2

  defmodule Feed do
    defstruct author: nil,       # Atom
              title: nil,        # Atom, RSS2
              description: nil,  # RSS2
              link: nil,         # Atom, RSS2
              id: nil,           # Atom
              updated: nil,      # Atom, RSS2 (pubDate)
              entries: []
  end

  defmodule Entry do
    defstruct title: nil,        # Atom, RSS2
              link: nil,         # Atom, RSS2
              description: nil,  # RSS2
              id: nil,           # Atom, RSS2(guid)
              updated: nil,      # Atom, RSS2(pubDate)
              summary: nil,      # Atom
              content: nil       # Atom, RSS2(content:encoded)
  end

  def parse(xml_string) do
    XmlNode.parse_string(xml_string) |> determine_feed_parser |> parse_document
  end

  def fetch_and_parse(_url) do
    # TODO: implement me
  end

  def determine_feed_parser(xml) do
    cond do
      Atom.can_parse?(xml) -> {:ok, Atom, xml}
      RSS2.can_parse?(xml) -> {:ok, RSS2, xml}
      true -> {:error, "Feed format unknown"}
    end
  end

  defp parse_document({:ok, parser, xml}), do: parser.parse(xml)
  defp parse_document(_other), do: _other
end
