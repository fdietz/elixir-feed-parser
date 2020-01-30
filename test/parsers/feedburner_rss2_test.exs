defmodule ElixirFeedParser.Test.FeedburnerRSS2Test do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.FeedburnerRSS2

  setup do
    example1_file = File.read!("test/fixtures/rss2/TechCrunch.xml")

    example1 =
      with {:ok, xml} <- XmlNode.parse_string(example1_file), do: FeedburnerRSS2.parse(xml)

    {:ok, [example1: example1]}
  end

  test "can_parse?" do
    sample_xml = """
    <?xml version="1.0" encoding="UTF-8" ?>
    <rss version="2.0" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0">
      <title>Example Feed</title>
    </rss>
    """

    {:ok, xml} = XmlNode.parse_string(sample_xml)
    assert FeedburnerRSS2.can_parse?(xml)
  end

  test "parse feed burner hub", %{example1: feed} do
    assert feed.hubs == [
             "http://pubsubhubbub.appspot.com/",
             "http://techcrunch.com/?pushpress=hub"
           ]
  end
end
