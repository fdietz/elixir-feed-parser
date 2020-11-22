defmodule ElixirFeedParser.Parsers.FeedburnerAtom do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.XmlNode

  # TODO: implement me
  def can_parse?(xml) do
    Atom.can_parse?(xml) && feedburner_namespace?(xml)
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/feed")

    xml
    |> Atom.parse()
    |> Map.merge(%{
      hubs: feed |> elements("atom10:link[@rel='hub']", attr: "href"),
      feed_url: feed |> element("link[@type='application/atom+xml']", attr: "href"),
      entries: parse_entries(feed)
    })
  end

  def parse_entry(feed, entry) do
    feed
    |> Atom.parse_entry(entry)
    |> Map.merge(%{
      url: feed_entry_url(entry)
    })
  end

  defp feed_entry_url(entry) do
    links = entry |> elements("link", attr: "href")
    fb_url = entry |> element("feedburner:origLink")

    if fb_url do
      fb_url
    else
      List.first(links)
    end
  end

  defp parse_entries(feed) do
    XmlNode.map_children(feed, "entry", fn e -> parse_entry(feed, e) end)
  end

  defp feedburner_namespace?(xml) do
    namespaces = xml |> XmlNode.find("/feed") |> XmlNode.namespaces()
    namespaces["feedburner"] == "http://rssnamespace.org/feedburner/ext/1.0"
  end
end
