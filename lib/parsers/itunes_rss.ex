defmodule ElixirFeedParser.Parsers.ITunesRSS2 do
  import ElixirFeedParser.Parsers.Helper
  alias ElixirFeedParser.XmlNode

  # TODO: remove duplication with ElixirFeedParser.Parsers.RSS2
  # http://www.apple.com/itunes/whatson/podcasts/specs.html
  def can_parse?(xml) do
    rss = XmlNode.find(xml, "/rss")
    XmlNode.attr(rss, "version") == "2.0" && XmlNode.namespaces(rss)["itunes"] == "http://www.itunes.com/dtds/podcast-1.0.dtd"
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/rss/channel")

    %{
      title:                 feed |> element("title"),
      description:           feed |> element("description"),
      url:                   feed |> element("link"),
      language:              feed |> element("language"),
      copyright:             feed |> element("copyright"),
      link:                  feed |> element("link"),
      "rss2:managingEditor": feed |> element("managingEditor"),
      "rss2:webMaster":      feed |> element("webMaster"),
      # TODO: also work with pubdate or publicationDate
      updated:               feed |> element("pubDate"),
      "rss2:pubDate":        feed |> element("pubDate"),
      "rss2:lastBuildDate":  feed |> element("lastBuildDate"),
      generator:             feed |> element("generator"),
      "rss2:ttl":            feed |> element("ttl"),
      # TODO: integer
      skip_hours:            feed |> elements("skipHours/hour"),
      "rss2:skipHours":      feed |> elements("skipHours/hour"),
      skip_days:             feed |> elements("skipDays/day"),
      "rss2:skipDays":       feed |> elements("skipDays/day"),

      itunes_author:         feed |> element("itunes:author"),
      itunes_block:          feed |> element("itunes:block"),
      itunes_image:          feed |> element("itunes:image", [attr: "href"]),
      itunes_explicit:       feed |> element("itunes:explicit"),
      itunes_keywords:       feed |> element("itunes:keywords"),
      itunes_new_feed_url:   feed |> element("itunes:new_feed_url"),
      itunes_subtitle:       feed |> element("itunes:subtitle"),
      itunes_summary:        feed |> element("itunes:summary"),
      categories:            feed |> elements("itunes:category", [attr: "text"]),
      itunes_category:       feed |> elements("itunes:category", [attr: "text"]),

      itunes_owners:         parse_itunes_owners(feed),
      entries:               parse_entries(feed)
    }
  end

  defp parse_itunes_owners(feed) do
    XmlNode.map_children(feed, "itunes:owner", fn(owner) ->
      %{
        itunes_name: owner |> element("itunes:name"),
        itunes_email: owner |> element("itunes:email")
      }
    end)
  end
  defp parse_entries(feed) do
    XmlNode.map_children(feed, "item", fn(e) -> parse_entry(feed, e) end)
  end

  defp parse_entry(feed, entry) do
    author     = entry |> element("author")
    dc_creator = entry |> element("dc:creator")

    %{
      title:          entry |> element("title"),
      link:           entry |> element("link"),
      "rss2:link":    entry |> element("link"),
      description:    entry |> element("description"),
      author:         author || dc_creator,
      "rss2:dc:creator": entry |> element("dc:creator"),
      categories:     entry |> elements("category"),
      # support dc:identifier too
      id:             entry |> element("guid"),
      "rss2:guid":    entry |> element("guid"),
      # TODO: also work with pubdate or publicationDate, dc:date, dc:Date, dcterms:created
      updated:        entry |> element("pubDate"),
      "rss2:pubDate": entry |> element("pubDate"),
      content:        entry |> element("content:encoded"),
      enclosure:      entry |> XmlNode.find("enclosure") |> parse_enclosure,

      itunes_author:    entry |> element("itunes:author"),
      itunes_block:     entry |> element("itunes:block"),
      itunes_duration:  entry |> element("itunes:duration"),
      itunes_explicit:  entry |> element("itunes:explicit"),
      itunes_keywords:  entry |> element("itunes:keywords"),
      itunes_subtitle:  entry |> element("itunes:subtitle"),
      itunes_image:     entry |> element("itunes:image", [attr: "href"]),
      itunes_order:     entry |> element("itunes:order"),
      itunes_summary:   entry |> element("itunes:summary"),
      itunes_is_closed_captioned:   entry |> element("itunes:isClosedCaptioned")
    }
  end

  defp parse_enclosure(nil), do: nil
  defp parse_enclosure(enclosure) do
    %{
      url:    enclosure |> XmlNode.attr("url"),
      length: enclosure |> XmlNode.attr("length"),
      type:   enclosure |> XmlNode.attr("type")
    }
  end

end
