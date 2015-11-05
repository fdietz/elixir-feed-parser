defmodule ElixirFeedParser.Test.FeedburnerRSS2Test do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.RSS2

  setup do
    example1_file = File.read!("test/fixtures/rss2/TechCrunch.xml")
    example1 = XmlNode.parse_string(example1_file) |> RSS2.parse
    {:ok, [example1: example1]}
  end

  test "parse feed burner hub", %{example1: feed} do
    assert feed.hubs == ["http://pubsubhubbub.appspot.com/", "http://techcrunch.com/?pushpress=hub"]
  end
end
