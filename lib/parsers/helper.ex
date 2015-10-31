defmodule ElixirFeedParser.Parsers.Helper do

  # always take url if provided
  # if no feed_url link entry, take last link entry
  def parse_url(nil, links), do: List.last(links)
  def parse_url(url, _links), do: url

  # always take url if provided
  # otherwise take last link entry - the feed_url link entry
  # if no feed_url link entry, take last link entry
  def parse_url(url, [], nil), do: url
  def parse_url(nil, links, nil), do: List.last(links)
  def parse_url(nil, links, feed_url), do: List.last(links -- [feed_url])
  def parse_url(url, _links, _feed_url), do: url

end
