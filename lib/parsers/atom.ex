defmodule ElixirFeedParser.Parsers.Atom do
  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Feed
  alias ElixirFeedParser.Entry

  def can_parse?(xml) do
    xml
    |> XmlNode.find("/feed")
    |> XmlNode.namespace() == "http://www.w3.org/2005/Atom"
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/feed")
    %Feed{
      author:  feed |> XmlNode.find("./author/name") |> XmlNode.text,
      title:   feed |> XmlNode.find("title") |> XmlNode.text,
      id:      feed |> XmlNode.find("id") |> XmlNode.text,
      link:    feed |> XmlNode.find("link") |> XmlNode.attr("href"),
      updated: feed |> XmlNode.find("updated") |> XmlNode.text,
      entries: parse_entries(feed)
    }
  end

  defp parse_entries(xml) do
    XmlNode.map_children(xml, "entry", fn(e) -> parse_entry(e) end)
  end

  defp parse_entry(entry) do
    %Entry{
      title:   entry |> XmlNode.find("title") |> XmlNode.text,
      link:    entry |> XmlNode.find("link") |> XmlNode.attr("href"),
      id:      entry |> XmlNode.find("id") |> XmlNode.text,
      updated: entry |> XmlNode.find("updated") |> XmlNode.text,
      summary: entry |> XmlNode.find("summary") |> XmlNode.text,
      content: entry |> XmlNode.find("content") |> XmlNode.text
    }
  end
end
