defmodule ElixirFeedParser.Parsers.RSS2 do
  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Feed
  alias ElixirFeedParser.Entry

  def can_parse?(xml) do
    xml
    |> XmlNode.find("/rss")
    |> XmlNode.attr("version") == "2.0"
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/rss/channel")
    %Feed{
      title:       feed |> XmlNode.find("title") |> XmlNode.text,
      description: feed |> XmlNode.find("description") |> XmlNode.text,
      link:        feed |> XmlNode.find("link") |> XmlNode.text,
      updated:     feed |> XmlNode.find("pubDate") |> XmlNode.text,
      entries:     parse_entries(feed)
    }
  end

  defp parse_entries(xml) do
    XmlNode.map_children(xml, "item", fn(e) -> parse_entry(e) end)
  end

  defp parse_entry(entry) do
    %Entry{
      title:       entry |> XmlNode.find("title") |> XmlNode.text,
      description: entry |> XmlNode.find("description") |> XmlNode.text,
      link:        entry |> XmlNode.find("link") |> XmlNode.text,
      id:          entry |> XmlNode.find("guid") |> XmlNode.text,
      updated:     entry |> XmlNode.find("pubDate") |> XmlNode.text,
      content:     entry |> XmlNode.find("content:encoded") |> XmlNode.text
    }
  end
end
