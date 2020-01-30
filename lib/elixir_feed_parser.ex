defmodule ElixirFeedParser do
  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.Parsers.RSS2
  alias ElixirFeedParser.Parsers.GoogleDocsAtom
  alias ElixirFeedParser.Parsers.ITunesRSS2
  alias ElixirFeedParser.Parsers.FeedburnerAtom
  alias ElixirFeedParser.Parsers.FeedburnerRSS2

  @type parser ::
          :atom | :rss2 | :google_docs | :itunes | :feedburner_atom | :feedburner_rss2

  @spec parse(String.t(), parser()) :: {:ok | map()} | {:error, String.t()}
  def parse(xml_string, parser) do
    with {:ok, xml} <- XmlNode.parse_string(xml_string),
         {:ok, parser} <- atom_to_parser(parser) do
      {:ok, parser.parse(xml)}
    end
  end

  defp atom_to_parser(:atom), do: {:ok, Atom}
  defp atom_to_parser(:rss2), do: {:ok, RSS2}
  defp atom_to_parser(:google_docs), do: {:ok, GoogleDocsAtom}
  defp atom_to_parser(:itunes), do: {:ok, ITunesRSS2}
  defp atom_to_parser(:feedburner_atom), do: {:ok, FeedburnerAtom}
  defp atom_to_parser(:feedburner_rss2), do: {:ok, FeedburnerRSS2}
  defp atom_to_parser(unknown), do: {:error, "Parse #{inspect(unknown)}, not implemented"}

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
