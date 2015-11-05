defmodule ElixirFeedParser.Test.FeedburnerAtomTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom

  setup do
    example1_file = File.read!("test/fixtures/atom/FeedBurnerXHTML.xml")
    example1 = XmlNode.parse_string(example1_file) |> Atom.parse
    example2_file = File.read!("test/fixtures/atom/PaulDixExplainsNothing.xml")
    example2 = XmlNode.parse_string(example2_file) |> Atom.parse
    example3_file = File.read!("test/fixtures/atom/TypePadNews.xml")
    example3 = XmlNode.parse_string(example3_file) |> Atom.parse
    {:ok, [example1: example1, example2: example2, example3: example3]}
  end

  test "parse feed burner url", %{example1: feed} do
    assert feed.url == "http://www.rotoauthority.com/"
  end

  test "parse feed burner feed_url", %{example1: feed} do
    assert feed.feed_url == "http://www.typepad.com/t/atom/weblog/blog_id=182926"
  end

  test "parse feed burner hubs", %{example1: feed} do
    assert feed.hubs == ["http://pubsubhubbub.appspot.com/"]
  end

  test "parse the feed burner feed_url 2", %{example2: feed} do
    assert feed.feed_url == "http://feeds.feedburner.com/PaulDixExplainsNothing"
  end

  test "parse feed burner hubs 2", %{example3: feed} do
    assert feed.hubs == ["http://pubsubhubbub.appspot.com/"]
  end
end
