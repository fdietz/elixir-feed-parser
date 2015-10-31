defmodule ElixirFeedParser do
  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.Parsers.RSS2

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
