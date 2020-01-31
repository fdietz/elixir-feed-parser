defmodule ElixirFeedParser.Test.RSS2Test do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.RSS2

  setup do
    example1_file = File.read!("test/fixtures/rss2/example1.xml")
    example1 = with {:ok, xml} <- XmlNode.parse_string(example1_file), do: RSS2.parse(xml)
    example2_file = File.read!("test/fixtures/rss2/TenderLoveMaking.xml")
    example2 = with {:ok, xml} <- XmlNode.parse_string(example2_file), do: RSS2.parse(xml)
    example3_file = File.read!("test/fixtures/rss2/complex_heise_de.xml")
    example3 = with {:ok, xml} <- XmlNode.parse_string(example3_file), do: RSS2.parse(xml)
    {:ok, [example1: example1, example2: example2, example3: example3]}
  end

  test "can_parse?" do
    sample_xml = """
    <?xml version="1.0" encoding="UTF-8" ?>
    <rss version="2.0">
      <title>Example Feed</title>
    </rss>
    """

    {:ok, xml} = XmlNode.parse_string(sample_xml)
    assert RSS2.can_parse?(xml)
  end

  test "parse title", %{example1: feed} do
    assert feed.title == "Example feed title"
  end

  test "parse description", %{example1: feed} do
    assert feed.description == "Example description"
  end

  test "parse url", %{example1: feed} do
    assert feed.url == "http://www.example.com"
  end

  test "parse updated", %{example1: feed} do
    assert feed.updated == %DateTime{
             day: 20,
             hour: 12,
             minute: 30,
             month: 10,
             second: 0,
             microsecond: {0, 0},
             year: 2015,
             time_zone: "Etc/GMT+0",
             zone_abbr: "GMT",
             utc_offset: 0,
             std_offset: 0
           }
  end

  test "parse link as atom:link", %{example2: feed} do
    assert feed.url == "http://tenderlovemaking.com"
  end

  test "parse generator", %{example2: feed} do
    assert feed.generator == "http://wordpress.org/?v=2.7"
  end

  test "parse language", %{example2: feed} do
    assert feed.language == "en"
  end

  test "parse skipHours as skip_hours", %{example1: feed} do
    assert feed.skip_hours == ["1", "2"]
  end

  test "parse skipDays as skip_days", %{example1: feed} do
    assert feed.skip_days == ["1", "2"]
  end

  test "parse image title", %{example1: feed} do
    assert feed.image.title == "Example image title"
  end

  test "parse image description", %{example1: feed} do
    assert feed.image.description == "Example image description..."
  end

  test "parse image url", %{example1: feed} do
    assert feed.image.url == "http://www.example.com/image"
  end

  test "parse complex document", %{example3: feed} do
    assert feed.title == "heise online News"
  end
end
