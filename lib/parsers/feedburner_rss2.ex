defmodule ElixirFeedParser.Parsers.FeedburnerRSS2 do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.Parsers.RSS2
  alias ElixirFeedParser.XmlNode

  # http://www.apple.com/itunes/whatson/podcasts/specs.html
  def can_parse?(xml) do
    RSS2.can_parse?(xml) && feedburner_namespace?(xml)
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/rss/channel")

    xml
    |> RSS2.parse()
    |> Map.merge(%{
      hubs: feed |> elements("atom10:link[@rel='hub']", attr: "href"),
      entries: parse_entries(feed)
    })
  end

  def parse_entry(feed, entry) do
    feed
    |> RSS2.parse_entry(entry)
    |> Map.merge(%{
      url: entry |> element("feedburner:origLink")
    })
  end

  defp parse_entries(feed) do
    XmlNode.map_children(feed, "item", fn e -> parse_entry(feed, e) end)
  end

  defp feedburner_namespace?(xml) do
    namespaces = xml |> XmlNode.find("/rss") |> XmlNode.namespaces()
    namespaces["feedburner"] == "http://rssnamespace.org/feedburner/ext/1.0"
  end
end
