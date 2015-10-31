defmodule ElixirFeedParser.Parsers.RSS2 do
  alias ElixirFeedParser.XmlNode

  def can_parse?(xml) do
    xml
    |> XmlNode.find("/rss")
    |> XmlNode.attr("version") == "2.0"
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/rss/channel")

    link      = feed |> XmlNode.find("link") |> XmlNode.text
    atom_link = feed |> XmlNode.find("atom:link[@rel='self']") |> XmlNode.attr("href")
    url       = link || atom_link

    %{
      title:                 feed |> XmlNode.find("title") |> XmlNode.text,
      description:           feed |> XmlNode.find("description") |> XmlNode.text,
      url:                   url,
      "atom:link":           atom_link,
      "rss2:link":           feed |> XmlNode.find("link") |> XmlNode.text,
      language:              feed |> XmlNode.find("language") |> XmlNode.text,
      copyright:             feed |> XmlNode.find("copyright") |> XmlNode.text,
      "rss2:managingEditor": feed |> XmlNode.find("managingEditor") |> XmlNode.text,
      "rss2:webMaster":      feed |> XmlNode.find("webMaster") |> XmlNode.text,
      updated:               feed |> XmlNode.find("pubDate") |> XmlNode.text,
      "rss2:pubDate":        feed |> XmlNode.find("pubDate") |> XmlNode.text,
      "rss2:lastBuildDate":  feed |> XmlNode.find("lastBuildDate") |> XmlNode.text,
      categories:            feed |> XmlNode.map_children("category", fn(e) -> XmlNode.text(e) end),
      generator:             feed |> XmlNode.find("generator") |> XmlNode.text,
      "rss2:ttl":            feed |> XmlNode.find("ttl") |> XmlNode.text,
      # TODO: integer
      skip_hours:            feed |> XmlNode.map_children("skipHours/hour", fn(e) -> XmlNode.text(e) end),
      "rss2:skipHours":      feed |> XmlNode.map_children("skipHours/hour", fn(e) -> XmlNode.text(e) end),
      skip_days:             feed |> XmlNode.map_children("skipDays/day", fn(e) -> XmlNode.text(e) end),
      "rss2:skipDays":       feed |> XmlNode.map_children("skipDays/day", fn(e) -> XmlNode.text(e) end),

      image:                 feed |> XmlNode.find("image") |> parse_image,
      entries:               parse_entries(feed)
    }
  end

  defp parse_image(nil), do: nil
  defp parse_image(image) do
    %{
      title:       image |> XmlNode.find("title") |> XmlNode.text,
      link:        image |> XmlNode.find("link") |> XmlNode.text,
      url:         image |> XmlNode.find("url") |> XmlNode.text,
      width:       image |> XmlNode.find("width") |> XmlNode.text,
      height:      image |> XmlNode.find("height") |> XmlNode.text,
      description: image |> XmlNode.find("description") |> XmlNode.text
    }
  end

  defp parse_entries(xml) do
    XmlNode.map_children(xml, "item", fn(e) -> parse_entry(e) end)
  end

  defp parse_entry(entry) do
    author     = entry |> XmlNode.find("author") |> XmlNode.text
    dc_creator = entry |> XmlNode.find("dc:creator") |> XmlNode.text

    %{
      title:          entry |> XmlNode.find("title") |> XmlNode.text,
      url:            entry |> XmlNode.find("link") |> XmlNode.text,
      "rss2:link":    entry |> XmlNode.find("link") |> XmlNode.text,
      description:    entry |> XmlNode.find("description") |> XmlNode.text,
      author:         author || dc_creator,
      "rss2:dc:creator": entry |> XmlNode.find("dc:creator") |> XmlNode.text,
      categories:     entry |> XmlNode.map_children("category", fn(e) -> XmlNode.text(e) end),
      id:             entry |> XmlNode.find("guid") |> XmlNode.text,
      "rss2:guid":    entry |> XmlNode.find("guid") |> XmlNode.text,
      comments:       entry |> XmlNode.find("comments") |> XmlNode.text,
      updated:        entry |> XmlNode.find("pubDate") |> XmlNode.text,
      "rss2:pubDate": entry |> XmlNode.find("pubDate") |> XmlNode.text,
      source:         entry |> XmlNode.find("source") |> XmlNode.attr("url"),
      content:        entry |> XmlNode.find("content:encoded") |> XmlNode.text,
      enclosure:      entry |> XmlNode.find("enclosure") |> parse_enclosure
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
