defmodule ElixirFeedParser.Parsers.Atom do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.XmlNode

  @date_format "ISO_8601"

  def can_parse?(xml) do
    xml
    |> XmlNode.find("/feed")
    |> XmlNode.namespace() == "http://www.w3.org/2005/Atom"
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/feed")

    url = feed |> element("link[@type='text/html']", attr: "href")
    links = feed |> elements("link", attr: "href")
    feed_url = feed |> element("link[@rel='self']", attr: "href")

    %{
      authors: feed |> elements("author/name"),
      title: feed |> element("title"),
      id: feed |> element("id"),

      # TODO: handle type attr text/html/xhtml correctly
      description: feed |> element("subtitle"),
      "atom:subtitle": feed |> element("subtitle"),
      links: links,
      url: parse_feed_url(url, links, feed_url),
      hubs: feed |> elements("link[@rel='hub']", attr: "href"),
      feed_url: feed |> element("link[@rel='self']", attr: "href"),

      # TODO: add optional scheme and label attributes
      categories: feed |> elements("category", attr: "term"),
      contributors: feed |> elements("contributor/name"),
      updated: feed |> element("updated") |> to_date_time(@date_format),
      generator: feed |> element("generator", attr: "uri"),
      icon: feed |> element("icon"),
      logo: feed |> element("logo"),
      rights: feed |> element("rights"),
      entries: parse_entries(feed)
    }
  end

  def parse_entry(_feed, entry) do
    links = entry |> elements("link", attr: "href")
    enclosure = entry |> element("enclosure", attr: "href")
    media_content = entry |> element("media:content", attr: "url")

    content_type = entry |> element("content", attr: "type")

    content =
      case content_type do
        "xhtml" ->
          entry |> XmlNode.find("content") |> XmlNode.element_to_string()

        _other ->
          entry |> element("content")
      end

    %{
      authors: entry |> elements("author/name"),
      id: entry |> element("id"),
      title: entry |> element("title"),
      updated: entry |> element("updated") |> to_date_time(@date_format),
      published: entry |> element("published") |> to_date_time(@date_format),

      # TODO: add optional scheme and label attributes
      categories: entry |> elements("category", attr: "term"),
      contributors: entry |> elements("contributor/name"),
      generator: entry |> element("generator", attr: "uri"),
      rights: entry |> element("rights"),
      source: entry |> element("source"),
      links: links,
      url: feed_entry_url(entry),
      image: enclosure || media_content,
      summary: entry |> element("summary"),
      content: content
    }
  end

  # always take url if provided
  # otherwise take last link entry - the feed_url link entry
  # if no feed_url link entry, take last link entry
  defp parse_feed_url(url, [], nil), do: url
  defp parse_feed_url(nil, links, nil), do: List.last(links)
  defp parse_feed_url(nil, links, feed_url), do: List.last(links -- [feed_url])
  defp parse_feed_url(url, _links, _feed_url), do: url

  defp parse_entries(feed) do
    XmlNode.map_children(feed, "entry", fn e -> parse_entry(feed, e) end)
  end

  defp feed_entry_url(entry) do
    url = entry |> element("link[@type='text/html' and @rel='alternate']", attr: "href")
    links = entry |> elements("link", attr: "href")

    if url do
      url
    else
      List.last(links)
    end
  end
end
