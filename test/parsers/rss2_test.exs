defmodule ElixirFeedParser.Test.RSS2Test do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.RSS2

  setup do
    example1_file = File.read!("test/fixtures/rss2/example1.xml")
    example1 = XmlNode.parse_string(example1_file) |> RSS2.parse
    example2_file = File.read!("test/fixtures/rss2/TenderLoveMaking.xml")
    example2 = XmlNode.parse_string(example2_file) |> RSS2.parse
    {:ok, [example1: example1, example2: example2]}
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

  test "parse title", %{example1: feed} do
    assert "Example feed title" == feed.title
  end

  test "parse description", %{example1: feed} do
    assert "Example description" == feed.description
  end

  test "parse url", %{example1: feed} do
    assert "http://www.example.com" == feed.url
  end

  test "parse updated", %{example1: feed} do
    assert "Tue, 20 Oct 2015 12:30:00 +0000" == feed.updated
  end

  test "parse link as atom:link", %{example2: feed} do
    assert "http://tenderlovemaking.com" == feed.url
  end

  test "parse generator", %{example2: feed} do
    assert "http://wordpress.org/?v=2.7" == feed.generator
  end

  test "parse language", %{example2: feed} do
    assert "en" == feed.language
  end

  test "parse skipHours as skip_hours", %{example1: feed} do
    assert ["1", "2"] == feed.skip_hours
  end

  test "parse skipDays as skip_days", %{example1: feed} do
    assert ["1", "2"] == feed.skip_days
  end

  test "parse image title", %{example1: feed} do
    assert "Example image title" == feed.image.title
  end

  test "parse image description", %{example1: feed} do
    assert "Example image description..." == feed.image.description
  end

  test "parse image url", %{example1: feed} do
    assert "http://www.example.com/image" == feed.image.url
  end
end
