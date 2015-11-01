defmodule ElixirFeedParser.Parsers.Helper do
  alias ElixirFeedParser.XmlNode

  # always take url if provided
  # otherwise take last link entry - the feed_url link entry
  # if no feed_url link entry, take last link entry
  def parse_feed_url(url, [], nil), do: url
  def parse_feed_url(nil, links, nil), do: List.last(links)
  def parse_feed_url(nil, links, feed_url), do: List.last(links -- [feed_url])
  def parse_feed_url(url, _links, _feed_url), do: url

  # always take url if
  # if no feed_url link entry, take last link entry
  def parse_entry_url(nil, nil, links), do: List.last(links)
  def parse_entry_url([], nil, links), do: List.last(links)
  def parse_entry_url(nil, url, nil), do: url
  def parse_entry_url([], url, nil), do: url
  def parse_entry_url(feed_burner_original_link, nil, nil), do: feed_burner_original_link

  def parse_hubs(hubs, nil), do: hubs
  def parse_hubs(nil, feed_burner_hubs), do: feed_burner_hubs
  def parse_hubs([nil], feed_burner_hubs), do: feed_burner_hubs
  def parse_hubs(hubs, feed_burner_hubs), do: hubs ++ feed_burner_hubs

  def element(node, selector) do
    node |> XmlNode.find(selector) |> XmlNode.text
  end

  def element(node, selector, [attr: attr]) do
    node |> XmlNode.find(selector) |> XmlNode.attr(attr)
  end

  def elements(node, selector) do
    node |> XmlNode.map_children(selector, fn(e) -> XmlNode.text(e) end)
  end

  def elements(node, selector, [attr: attr]) do
    node |> XmlNode.map_children(selector, fn(e) -> XmlNode.attr(e, attr) end)
  end
end
