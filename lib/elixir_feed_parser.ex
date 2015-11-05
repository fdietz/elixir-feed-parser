defmodule ElixirFeedParser do
  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.Parsers.RSS2
  alias ElixirFeedParser.Parsers.GoogleDocsAtom
  alias ElixirFeedParser.Parsers.ITunesRSS2
  alias ElixirFeedParser.Parsers.FeedburnerAtom
  alias ElixirFeedParser.Parsers.FeedburnerRSS2

  def parse(xml_string) do
    XmlNode.parse_string(xml_string) |> determine_feed_parser |> parse_document
  end

  def fetch_and_parse(_url) do
    # TODO: implement me
  end

  def determine_feed_parser(xml) do
    cond do
      GoogleDocsAtom.can_parse?(xml) -> {:ok, GoogleDocsAtom, xml}
      ITunesRSS2.can_parse?(xml)     -> {:ok, ITunesRSS2, xml}
      FeedburnerAtom.can_parse?(xml) -> {:ok, FeedburnerAtom, xml}
      FeedburnerRSS2.can_parse?(xml) -> {:ok, FeedburnerRSS2, xml}
      Atom.can_parse?(xml)           -> {:ok, Atom, xml}
      RSS2.can_parse?(xml)           -> {:ok, RSS2, xml}
      true -> {:error, "Feed format unknown"}
    end
  end

  defp parse_document({:ok, parser, xml}), do: parser.parse(xml)
  defp parse_document(_other), do: _other
end
