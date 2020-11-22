defmodule ElixirFeedParser do
  @moduledoc false

  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.Parsers.FeedburnerAtom
  alias ElixirFeedParser.Parsers.FeedburnerRSS2
  alias ElixirFeedParser.Parsers.GoogleDocsAtom
  alias ElixirFeedParser.Parsers.ITunesRSS2
  alias ElixirFeedParser.Parsers.RSS2
  alias ElixirFeedParser.XmlNode

  def parse(xml_string) do
    with {:ok, xml} <- XmlNode.parse_string(xml_string),
         {:ok, parser, xml} <- determine_feed_parser(xml),
         do: {:ok, parser.parse(xml)}
  end

  def determine_feed_parser(xml) do
    cond do
      GoogleDocsAtom.can_parse?(xml) -> {:ok, GoogleDocsAtom, xml}
      ITunesRSS2.can_parse?(xml) -> {:ok, ITunesRSS2, xml}
      FeedburnerAtom.can_parse?(xml) -> {:ok, FeedburnerAtom, xml}
      FeedburnerRSS2.can_parse?(xml) -> {:ok, FeedburnerRSS2, xml}
      Atom.can_parse?(xml) -> {:ok, Atom, xml}
      RSS2.can_parse?(xml) -> {:ok, RSS2, xml}
      true -> {:error, :feed_format_unknown}
    end
  end

  def supported_feed_format?(xml_string) do
    {:ok, xml} = XmlNode.parse_string(xml_string)

    case determine_feed_parser(xml) do
      {:ok, _parser, _xml} ->
        true

      _ ->
        false
    end
  end
end
