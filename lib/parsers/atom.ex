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

    url      = feed |> XmlNode.find("link[@type='text/html']") |> XmlNode.attr("href")
    links    = feed |> XmlNode.map_children("link", fn(e) -> XmlNode.attr(e, "href") end)
    feed_url = feed |> XmlNode.find("link[@rel='self']") |> XmlNode.attr("href")
    hubs     = feed |> XmlNode.map_children("link[@rel='hub']", fn(e) -> XmlNode.attr(e, "href") end)

    %{
      authors:         feed |> XmlNode.map_children("author/name", fn(e) -> XmlNode.text(e) end),
      title:           feed |> XmlNode.find("title") |> XmlNode.text,
      id:              feed |> XmlNode.find("id") |> XmlNode.text,

      # TODO: handle type attr text/html/xhtml correctly
      description:     feed   |> XmlNode.find("subtitle") |> XmlNode.text,
      "atom:subtitle": feed |> XmlNode.find("subtitle") |> XmlNode.text,

      links:           links,
      url:             parse_url(url, links, feed_url),
      hubs:            hubs,
      feed_url:        feed_url,

      # TODO: add optional scheme and label attributes
      categories:      feed |> XmlNode.map_children("category", fn(e) -> XmlNode.attr(e, "term") end),
      contributors:    feed |> XmlNode.map_children("contributor/name", fn(e) -> XmlNode.text(e) end),
      updated:         feed |> XmlNode.find("updated") |> XmlNode.text,

      generator:       feed |> XmlNode.find("generator") |> XmlNode.attr("uri"),
      icon:            feed |> XmlNode.find("icon") |> XmlNode.text,
      logo:            feed |> XmlNode.find("logo") |> XmlNode.text,
      rights:          feed |> XmlNode.find("rights") |> XmlNode.text,

      entries:         parse_entries(feed)
    }
  end

  defp parse_entries(xml) do
    XmlNode.map_children(xml, "entry", fn(e) -> parse_entry(e) end)
  end

  defp parse_entry(entry) do
    url      = entry |> XmlNode.find("link[@type='text/html']") |> XmlNode.attr("href")
    links    = entry |> XmlNode.map_children("link", fn(e) -> XmlNode.attr(e, "href") end)

    %{
      authors:      entry |> XmlNode.map_children("author/name", fn(e) -> XmlNode.text(e) end),
      id:           entry |> XmlNode.find("id") |> XmlNode.text,
      title:        entry |> XmlNode.find("title") |> XmlNode.text,
      updated:      entry |> XmlNode.find("updated") |> XmlNode.text,
      published:    entry |> XmlNode.find("published") |> XmlNode.text,

      # TODO: add optional scheme and label attributes
      categories:   entry |> XmlNode.map_children("category", fn(e) -> XmlNode.attr(e, "term") end),
      contributors: entry |> XmlNode.map_children("contributor/name", fn(e) -> XmlNode.text(e) end),

      generator:    entry |> XmlNode.find("generator") |> XmlNode.attr("uri"),
      rights:       entry |> XmlNode.find("rights") |> XmlNode.text,
      source:       entry |> XmlNode.find("source") |> XmlNode.text,

      links:        links,
      url:          parse_url(url, links),

      summary:      entry |> XmlNode.find("summary") |> XmlNode.text,
      content:      entry |> XmlNode.find("content") |> XmlNode.text
    }
  end

end
