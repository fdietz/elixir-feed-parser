defmodule ElixirFeedParser do
  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.Parsers.RSS2
  alias ElixirFeedParser.Parsers.GoogleDocsAtom
  alias ElixirFeedParser.Parsers.ITunesRSS2
  alias ElixirFeedParser.Parsers.FeedburnerAtom
  alias ElixirFeedParser.Parsers.FeedburnerRSS2

  def parse(xml_string) do
    case XmlNode.parse_string(xml_string) do
      {:ok, xml_node} ->
        case xml_node |> determine_feed_parser |> parse_document do
          %{} = result ->
            {:ok, result}
          {:error, reason} ->
            {:error, reason}
        end
      {:error, error} ->
        {:error, error}
     end
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
  defp parse_document(other), do: other
end
