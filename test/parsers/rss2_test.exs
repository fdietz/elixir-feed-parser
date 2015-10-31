defmodule ElixirFeedParser.Test.RSS2Test do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.RSS2

  setup do
    example1_file = File.read!("test/fixtures/rss2/example1.xml")
    example1 = XmlNode.parse_string(example1_file)
    {:ok, [example1: example1]}
  end

  test "can_parse?" do
    sample_xml = """
    <?xml version="1.0" encoding="UTF-8" ?>
    <rss version="2.0">
      <title>Example Feed</title>
    </rss>
    """
    xml = XmlNode.parse_string(sample_xml)
    assert RSS2.can_parse?(xml)
  end

  test "parse", %{example1: example1} do
    feed = RSS2.parse(example1)
    assert Enum.count(feed.entries) == 1
    assert "Example feed title", feed.title
    assert "Example description", feed.description
    assert "http://example.com/", feed.link
    assert "Tue, 20 Oct 2015 12:30:00 +000", feed.updated
  end

  test "parse_entry", %{example1: example1} do
    feed = RSS2.parse(example1)
    assert List.first(feed.entries) == %{
      title: "Example item title",
      description: "Example item description",
      link: "http://www.example.com/items/1.html",
      id: "urn:uuid:763ba33d-bbbe-4025-9d6f-9a39d16b164e",
      updated: "Tue, 20 Oct 2015 12:30:00 +0000",
      content: "Example content with <a href=\"bla\">link</a><p>my test <em>paragraph</em> is here.</p>"
    }
  end
end
