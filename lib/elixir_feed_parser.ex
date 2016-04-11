defmodule ElixirFeedParser do
  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.Parsers.RSS2
  alias ElixirFeedParser.Parsers.GoogleDocsAtom
  alias ElixirFeedParser.Parsers.ITunesRSS2
  alias ElixirFeedParser.Parsers.FeedburnerAtom
  alias ElixirFeedParser.Parsers.FeedburnerRSS2

  def parse(xml_string) do
    with {:ok, xml}         <- XmlNode.parse_string(xml_string),
         {:ok, parser, xml} <- determine_feed_parser(xml),
         %{} = parsed_feed  <- parser.parse(xml),
         do: {:ok, parsed_feed}
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

end
