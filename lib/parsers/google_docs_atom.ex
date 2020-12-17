defmodule ElixirFeedParser.Parsers.GoogleDocsAtom do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.Parsers.Atom
  alias ElixirFeedParser.XmlNode

  def can_parse?(xml) do
    Atom.can_parse?(xml) && google_docs_namespace?(xml)
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/feed")

    xml
    |> Atom.parse()
    |> Map.merge(%{
      feed_url: feed |> element("link[@type='application/atom+xml']", attr: "href"),
      entries: parse_entries(feed)
    })
  end

  def parse_entry(feed, entry) do
    feed
    |> Atom.parse_entry(entry)
    |> Map.merge(%{
      checksum: entry |> element("docs:md5Checksum"),
      original_filename: entry |> element("docs:filename"),
      suggested_filename: entry |> element("docs:suggestedFilename")
    })
  end

  defp parse_entries(feed) do
    XmlNode.map_children(feed, "entry", fn e -> parse_entry(feed, e) end)
  end

  defp google_docs_namespace?(xml) do
    namespaces = xml |> XmlNode.find("/feed") |> XmlNode.namespaces()
    namespaces["docs"] == "http://schemas.google.com/docs/2007"
  end
end
