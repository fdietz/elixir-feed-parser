defmodule ElixirFeedParser.Test.ITunesRSS2Test do
  use ExUnit.Case

  alias ElixirFeedParser.Parsers.ITunesRSS2
  alias ElixirFeedParser.XmlNode

  setup do
    example1_file = File.read!("test/fixtures/rss2/itunes.xml")
    example1 = with {:ok, xml} <- XmlNode.parse_string(example1_file), do: ITunesRSS2.parse(xml)
    {:ok, [example1: example1]}
  end

  test "can_parse?" do
    sample_xml = """
    <?xml version="1.0" encoding="UTF-8" ?>
    <rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
      <title>Example Feed</title>
    </rss>
    """

    {:ok, xml} = XmlNode.parse_string(sample_xml)
    assert ITunesRSS2.can_parse?(xml)
  end

  test "parse title", %{example1: feed} do
    assert feed.title == "All About Everything"
  end

  test "parse subtitle", %{example1: feed} do
    assert feed.itunes_subtitle == "A show about everything"
  end

  test "parse author", %{example1: feed} do
    assert feed.itunes_author == "John Doe"
  end

  test "parse an owner", %{example1: feed} do
    assert Enum.count(feed.itunes_owners) == 1
  end

  test "parse an image", %{example1: feed} do
    assert feed.itunes_image == "http://example.com/podcasts/everything/AllAboutEverything.jpg"
  end

  test "parse categories", %{example1: feed} do
    assert Enum.count(feed.categories) == 3
    assert Enum.at(feed.categories, 0) == "Technology"
    assert Enum.at(feed.categories, 1) == "Gadgets"
    assert Enum.at(feed.categories, 2) == "TV & Film"
  end

  test "parse summary", %{example1: feed} do
    assert feed.itunes_summary ==
             "All About Everything is a show about everything. Each week we dive into any subject known to man and talk about it as much as we can. Look for our Podcast in the iTunes Music Store"
  end

  test "parse entries", %{example1: feed} do
    assert Enum.count(feed.entries) == 3
  end
end
