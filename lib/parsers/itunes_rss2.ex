defmodule ElixirFeedParser.Parsers.ITunesRSS2 do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.Parsers.RSS2
  alias ElixirFeedParser.XmlNode

  # http://www.apple.com/itunes/whatson/podcasts/specs.html
  def can_parse?(xml) do
    RSS2.can_parse?(xml) && itunes_namespace?(xml)
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/rss/channel")

    xml
    |> RSS2.parse()
    |> Map.merge(%{
      itunes_author: feed |> element("itunes:author"),
      itunes_block: feed |> element("itunes:block"),
      itunes_image: feed |> element("itunes:image", attr: "href"),
      itunes_explicit: feed |> element("itunes:explicit"),
      itunes_keywords: feed |> element("itunes:keywords"),
      itunes_new_feed_url: feed |> element("itunes:new_feed_url"),
      itunes_subtitle: feed |> element("itunes:subtitle"),
      itunes_summary: feed |> element("itunes:summary"),
      categories: feed |> elements("itunes:category", attr: "text"),
      itunes_category: feed |> elements("itunes:category", attr: "text"),
      itunes_owners: parse_itunes_owners(feed),
      entries: parse_entries(feed)
    })
  end

  def parse_entry(feed, entry) do
    feed
    |> RSS2.parse_entry(entry)
    |> Map.merge(%{
      itunes_author: entry |> element("itunes:author"),
      itunes_block: entry |> element("itunes:block"),
      itunes_duration: entry |> element("itunes:duration"),
      itunes_explicit: entry |> element("itunes:explicit"),
      itunes_keywords: entry |> element("itunes:keywords"),
      itunes_subtitle: entry |> element("itunes:subtitle"),
      itunes_image: entry |> element("itunes:image", attr: "href"),
      itunes_order: entry |> element("itunes:order"),
      itunes_summary: entry |> element("itunes:summary"),
      itunes_is_closed_captioned: entry |> element("itunes:isClosedCaptioned")
    })
  end

  defp parse_itunes_owners(feed) do
    XmlNode.map_children(feed, "itunes:owner", fn owner ->
      %{
        itunes_name: owner |> element("itunes:name"),
        itunes_email: owner |> element("itunes:email")
      }
    end)
  end

  defp parse_entries(feed) do
    XmlNode.map_children(feed, "item", fn e -> parse_entry(feed, e) end)
  end

  defp itunes_namespace?(xml) do
    namespaces = xml |> XmlNode.find("/rss") |> XmlNode.namespaces()
    namespaces["itunes"] == "http://www.itunes.com/dtds/podcast-1.0.dtd"
  end
end
