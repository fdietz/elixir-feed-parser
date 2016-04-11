defmodule ElixirFeedParser.Test.FeedburnerRSS2EntryTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.FeedburnerRSS2

  setup do
    example1_file = File.read!("test/fixtures/rss2/TechCrunch.xml")
    example1 = with {:ok, xml} <- XmlNode.parse_string(example1_file), do: FeedburnerRSS2.parse(xml)
    {:ok, [example1: List.first(example1.entries)]}
  end

  test "parse feed burner origLink", %{example1: feed} do
    assert feed.url == "http://techcrunch.com/2011/11/02/angies-list-prices-ipo-at-11-to-13-per-share-valued-at-over-600m/"
  end
end
