defmodule ElixirFeedParser.Parsers.RSS2 do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.XmlNode

  @date_format "RFC_1123"

  def can_parse?(xml) do
    xml
    |> XmlNode.find("/rss")
    |> XmlNode.attr("version") == "2.0"
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/rss/channel")

    link = feed |> element("link")
    atom_link = feed |> element("atom:link[@rel='self']", attr: "href")
    url = link || atom_link

    %{
      title: feed |> element("title"),
      description: feed |> element("description"),
      url: url,
      hubs: [feed |> element("atom:link[@rel='self']", attr: "href")],
      "atom:link": atom_link,
      "rss2:link": feed |> element("link"),
      language: feed |> element("language"),
      copyright: feed |> element("copyright"),
      "rss2:managingEditor": feed |> element("managingEditor"),
      "rss2:webMaster": feed |> element("webMaster"),
      # TODO: also work with pubdate or publicationDate
      updated: feed |> element("pubDate") |> to_date_time(@date_format),
      "rss2:pubDate": feed |> element("pubDate") |> to_date_time(@date_format),
      "rss2:lastBuildDate": feed |> element("lastBuildDate") |> to_date_time(@date_format),
      categories: feed |> elements("category"),
      generator: feed |> element("generator"),
      "rss2:ttl": feed |> element("ttl"),
      # TODO: integer
      skip_hours: feed |> elements("skipHours/hour"),
      "rss2:skipHours": feed |> elements("skipHours/hour"),
      skip_days: feed |> elements("skipDays/day"),
      "rss2:skipDays": feed |> elements("skipDays/day"),
      image: feed |> XmlNode.find("image") |> parse_image,
      entries: parse_entries(feed)
    }
  end

  def parse_entry(_feed, entry) do
    author = entry |> element("author")
    dc_creator = entry |> element("dc:creator")

    %{
      title: entry |> element("title"),
      url: entry |> element("link"),
      "rss2:link": entry |> element("link"),
      description: entry |> element("description"),
      author: author || dc_creator,
      "rss2:dc:creator": entry |> element("dc:creator"),
      categories: entry |> elements("category"),
      "rss2:thumbnail": entry |> element("media:thumbnail", attr: "url"),
      # support dc:identifier too
      id: entry |> element("guid"),
      "rss2:guid": entry |> element("guid"),
      comments: entry |> element("comments"),
      # TODO: also work with pubdate or publicationDate, dc:date, dc:Date, dcterms:created
      updated: entry |> element("pubDate") |> to_date_time(@date_format),
      "rss2:pubDate": entry |> element("pubDate") |> to_date_time(@date_format),
      source: entry |> element("source", attr: "url"),
      content: entry |> element("content:encoded"),
      enclosure: entry |> XmlNode.find("enclosure") |> parse_enclosure
    }
  end

  defp parse_image(nil), do: nil

  defp parse_image(image) do
    %{
      title: image |> element("title"),
      link: image |> element("link"),
      url: image |> element("url"),
      width: image |> element("width"),
      height: image |> element("height"),
      description: image |> element("description")
    }
  end

  defp parse_entries(feed) do
    XmlNode.map_children(feed, "item", fn e -> parse_entry(feed, e) end)
  end

  defp parse_enclosure(nil), do: nil

  defp parse_enclosure(enclosure) do
    %{
      url: enclosure |> XmlNode.attr("url"),
      length: enclosure |> XmlNode.attr("length"),
      type: enclosure |> XmlNode.attr("type")
    }
  end
end
