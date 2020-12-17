defmodule ElixirFeedParser.Test.FeedburnerRSS2EntryTest do
  use ExUnit.Case

  alias ElixirFeedParser.Parsers.FeedburnerRSS2
  alias ElixirFeedParser.XmlNode

  setup do
    example1_file = File.read!("test/fixtures/rss2/TechCrunch.xml")
    example2_file = File.read!("test/fixtures/rss2/rsn_cnn.xml")

    example1 =
      with {:ok, xml} <- XmlNode.parse_string(example1_file), do: FeedburnerRSS2.parse(xml)

    example2 =
      with {:ok, xml} <- XmlNode.parse_string(example2_file), do: FeedburnerRSS2.parse(xml)

    {:ok, [example1: List.first(example1.entries), example2: List.first(example2.entries)]}
  end

  test "parse feed burner origLink", %{example1: feed} do
    assert feed.url ==
             "http://techcrunch.com/2011/11/02/angies-list-prices-ipo-at-11-to-13-per-share-valued-at-over-600m/"
  end

  test "parse url for thumbnail", %{example2: feed} do
    assert feed."rss2:thumbnail" ==
             "http://i2.cdn.turner.com/money/dam/assets/170920161756-facebook-logo-wall-120x90.jpg"
  end
end
