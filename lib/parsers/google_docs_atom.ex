defmodule ElixirFeedParser.Parsers.GoogleDocsAtom do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.XmlNode

  # TODO: remove code duplication with ElixirFeedParser.Parsers.Atom

  def can_parse?(xml) do
    feed = XmlNode.find(xml, "/feed")
    XmlNode.namespace(feed) == "http://www.w3.org/2005/Atom" && XmlNode.namespaces(feed)["docs"] == "http://schemas.google.com/docs/2007"
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/feed")

    url      = feed |> element("link[@type='text/html']", [attr: "href"])
    links    = feed |> elements("link", [attr: "href"])

    %{
      authors:         feed |> elements("author/name"),
      title:           feed |> element("title"),
      id:              feed |> element("id"),

      # TODO: handle type attr text/html/xhtml correctly
      description:     feed |> element("subtitle"),

      links:           links,
      url:             url,
      feed_url:        feed |> element("link[@type='application/atom+xml']", [attr: "href"]),
      entries:         parse_entries(feed)
    }
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

      generator:    entry |> element("generator", [attr: "uri"]),
      rights:       entry |> element("rights"),
      source:       entry |> element("source"),

      links:        links,
      url:          entry |> element("link[@type='text/html' and @rel='alternate']", [attr: "href"]),
      summary:      entry |> element("summary"),
      content:      entry |> element("content"),

      checksum:           entry |> element("docs:md5Checksum"),
      original_filename:  entry |> element("docs:filename"),
      suggested_filename: entry |> element("docs:suggestedFilename")
    }
  end


end

