defmodule ElixirFeedParser.Test.ITunesRSS2EntryTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.ITunesRSS2

  setup do
    example1_file = File.read!("test/fixtures/rss2/itunes.xml")
    example1 = XmlNode.parse_string(example1_file) |> ITunesRSS2.parse
    {:ok, [example1: List.first(example1.entries)]}
  end

  test "parse title", %{example1: entry} do
    assert entry.title == "Shake Shake Shake Your Spices"
  end
  test "parse author", %{example1: entry} do
    assert entry.itunes_author == "John Doe"
  end

  test "parse the subtitle", %{example1: entry} do
    assert entry.itunes_subtitle == "A short primer on table spices"
  end

  test "parse the summary", %{example1: entry} do
    assert entry.itunes_summary == "This week we talk about salt and pepper shakers, comparing and contrasting pour rates, construction materials, and overall aesthetics. Come and join the party!"
  end

  test "parse the enclosure", %{example1: entry} do
    assert entry.enclosure.length == "8727310"
    assert entry.enclosure.type == "audio/x-m4a"
    assert entry.enclosure.url == "http://example.com/podcasts/everything/AllAboutEverythingEpisode3.m4a"
  end

  test "parse the guid as id", %{example1: entry} do
    assert entry.id == "http://example.com/podcasts/archive/aae20050615.m4a"
  end

  test "parse the published date", %{example1: entry} do
    assert entry.updated == "Wed, 15 Jun 2005 19:00:00 GMT"
  end

  test "parse the duration", %{example1: entry} do
    assert entry.itunes_duration == "7:04"
  end

  test "parse the keywords", %{example1: entry} do
    assert entry.itunes_keywords == "salt, pepper, shaker, exciting"
  end

  test "parse the image", %{example1: entry} do
    assert entry.itunes_image == "http://example.com/podcasts/everything/AllAboutEverything.jpg"
  end

  test "parse the order", %{example1: entry} do
    assert entry.itunes_order == "12"
  end

  test "parse the closed captioned flag", %{example1: entry} do
    assert entry.itunes_is_closed_captioned == "yes"
  end

  test "parse the encoded content", %{example1: entry} do
    assert entry.content == "<p><strong>TOPIC</strong>: Gooseneck Options</p>"
  end

end

