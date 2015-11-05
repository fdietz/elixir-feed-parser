defmodule ElixirFeedParser.Parsers.Atom do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.XmlNode

  def can_parse?(xml) do
    xml
    |> XmlNode.find("/feed")
    |> XmlNode.namespace() == "http://www.w3.org/2005/Atom"
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/feed")

    url      = feed |> element("link[@type='text/html']", [attr: "href"])
    links    = feed |> elements("link", [attr: "href"])
    feed_url = feed |> element("link[@rel='self']", [attr: "href"])

    %{
      authors:         feed |> elements("author/name"),
      title:           feed |> element("title"),
      id:              feed |> element("id"),

      # TODO: handle type attr text/html/xhtml correctly
      description:     feed |> element("subtitle"),
      "atom:subtitle": feed |> element("subtitle"),

      links:           links,
      url:             parse_feed_url(url, links, feed_url),
      hubs:            hubs(feed),
      feed_url:        feed_url(feed),

      # TODO: add optional scheme and label attributes
      categories:      feed |> elements("category", [attr: "term"]),
      contributors:    feed |> elements("contributor/name"),
      updated:         feed |> element("updated"),
      generator:       feed |> element("generator", [attr: "uri"]),
      icon:            feed |> element("icon"),
      logo:            feed |> element("logo"),
      rights:          feed |> element("rights"),

      entries:         parse_entries(feed)
    }
  end

  # always take url if provided
  # otherwise take last link entry - the feed_url link entry
  # if no feed_url link entry, take last link entry
  defp parse_feed_url(url, [], nil), do: url
  defp parse_feed_url(nil, links, nil), do: List.last(links)
  defp parse_feed_url(nil, links, feed_url), do: List.last(links -- [feed_url])
  defp parse_feed_url(url, _links, _feed_url), do: url

  defp hubs(feed) do
    case feed_burner_namespace?(feed) do
      true  -> feed |> elements("atom10:link[@rel='hub']", [attr: "href"])
      false -> feed |> elements("link[@rel='hub']", [attr: "href"])
    end
  end

  defp feed_url(feed) do
    case feed_burner_namespace?(feed) do
      true  -> feed |> element("link[@type='application/atom+xml']", [attr: "href"])
      false -> feed |> element("link[@rel='self']", [attr: "href"])
    end
  end

  def feed_burner_namespace?(feed) do
    XmlNode.namespaces(feed)["feedburner"] == "http://rssnamespace.org/feedburner/ext/1.0"
  end

  defp parse_entries(feed) do
    XmlNode.map_children(feed, "entry", fn(e) -> parse_entry(feed, e) end)
  end

  defp parse_entry(feed, entry) do
    links         = entry |> elements("link", [attr: "href"])
    enclosure     = entry |> element("enclosure", [attr: "href"])
    media_content = entry |> element("media:content", [attr: "url"])

    %{
      authors:      entry |> elements("author/name"),
      id:           entry |> element("id"),
      title:        entry |> element("title"),
      updated:      entry |> element("updated"),
      published:    entry |> element("published"),

      # TODO: add optional scheme and label attributes
      categories:   entry |> elements("category", [attr: "term"]),
      contributors: entry |> elements("contributor/name"),

      generator:    entry |> element("generator", [attr: "uri"]),
      rights:       entry |> element("rights"),
      source:       entry |> element("source"),

      links:        links,
      url:          feed_entry_url(feed, entry),

      image:        enclosure || media_content,
      summary:      entry |> element("summary"),
      content:      entry |> element("content")
    }
  end

  defp feed_entry_url(feed, entry) do
    url    = entry |> element("link[@type='text/html' and @rel='alternate']", [attr: "href"])
    links  = entry |> elements("link", [attr: "href"])
    fb_url = entry |> element("feedburner:origLink")

    case feed_burner_namespace?(feed) do
      true  -> if fb_url do fb_url else List.first(links) end
      false -> if url do url else List.last(links) end
    end
  end

end
