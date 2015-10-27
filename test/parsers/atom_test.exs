defmodule ElixirFeedParser.Test.AtomTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom

  setup do
    example1_file = File.read!("test/fixtures/atom/example1.xml")
    example1 = XmlNode.parse_string(example1_file)
    {:ok, [example1: example1]}
  end

  test "can_parse?" do
    sample_xml = """
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <title>Example Feed</title>
    </feed>
    """
    xml = XmlNode.parse_string(sample_xml)
    assert Atom.can_parse?(xml)
  end

  test "parse", %{example1: example1} do
    feed = Atom.parse(example1)
    assert Enum.count(feed.entries) == 1
    assert "John Doe", feed.author
    assert "Example feed title", feed.title
    assert "http://example.org/", feed.link
    assert "urn:uuid:18f622d5-2f6a-4250-8e79-ddba87e4ecfd", feed.id
    assert "2003-12-13T18:30:02Z", feed.updated
  end

  test "parse_entry", %{example1: example1} do
    feed = Atom.parse(example1)
    assert List.first(feed.entries) == %ElixirFeedParser.Entry{
      title: "Example entry title",
      link: "http://example.com/entries/1.html",
      id: "urn:uuid:1a7532cc-0a6f-44e8-b09f-3c1803d02d78",
      updated: "2015-10-10T12:30:00Z",
      summary: "Example summary",
      content: "Example content with <a href=\"bla\">link</a><p>my test <em>paragraph</em> is here.</p>"
    }
  end
end
