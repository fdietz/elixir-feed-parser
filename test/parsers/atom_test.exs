defmodule ElixirFeedParser.Test.AtomTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom

  setup do
    example1_file = File.read!("test/fixtures/atom/example1.xml")
    example1 = with {:ok, xml} <- XmlNode.parse_string(example1_file), do: Atom.parse(xml)
    example2_file = File.read!("test/fixtures/atom/AmazonWebServicesBlog.xml")
    example2 = with {:ok, xml} <- XmlNode.parse_string(example2_file), do: Atom.parse(xml)
    example3_file = File.read!("test/fixtures/atom/atom_with_link_tag_for_url_unmarked.xml")
    example3 = with {:ok, xml} <- XmlNode.parse_string(example3_file), do: Atom.parse(xml)
    example4_file = File.read!("test/fixtures/atom/SamRuby.xml")
    example4 = with {:ok, xml} <- XmlNode.parse_string(example4_file), do: Atom.parse(xml)
    example5_file = File.read!("test/fixtures/atom/FeedjiraBlog.xml")
    example5 = with {:ok, xml} <- XmlNode.parse_string(example5_file), do: Atom.parse(xml)
    example6_file = File.read!("test/fixtures/atom/complex_the_verge_com.xml")
    example6 = with {:ok, xml} <- XmlNode.parse_string(example6_file), do: Atom.parse(xml)

    {:ok,
     [
       example1: example1,
       example2: example2,
       example3: example3,
       example4: example4,
       example5: example5,
       example6: example6
     ]}
  end

  test "can_parse?" do
    sample_xml = """
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <title>Example Feed</title>
    </feed>
    """

    {:ok, xml} = XmlNode.parse_string(sample_xml)
    assert Atom.can_parse?(xml)
  end

  test "can_parse? handles spaces between attributes" do
    sample_xml = """
    <?xml version="1.0" encoding="utf-8"?>
      <feed
        xmlns = "http://www.w3.org/2005/Atom"
        xmlns:cap = "urn:oasis:names:tc:emergency:cap:1.1"
        xmlns:ha = "http://www.alerting.net/namespace/index_1.0"
        >
      <title>Example Feed</title>
    </feed>
    """

    {:ok, xml} = XmlNode.parse_string(sample_xml)
    assert Atom.can_parse?(xml)
  end

  test "parse authors", %{example1: feed} do
    assert feed.authors == ["John Doe", "Ms. Penny"]
  end

  test "parse title", %{example1: feed} do
    assert feed.title == "Example feed title"
  end

  test "parse subtitle as description", %{example1: feed} do
    assert feed.description == "Example feed description"
  end

  test "parse subtitle as atom:subtitle", %{example1: feed} do
    assert feed[:"atom:subtitle"] == "Example feed description"
  end

  test "parse id", %{example1: feed} do
    assert feed.id == "urn:uuid:18f622d5-2f6a-4250-8e79-ddba87e4ecfd"
  end

  test "parse url", %{example2: feed} do
    assert feed.url == "http://aws.typepad.com/aws/"
  end

  test "parse url if does not have type 'text/html' attribute", %{example3: feed} do
    assert feed.url == "http://www.innoq.com/planet/"
  end

  test "parse url based on rel attribute", %{example5: feed} do
    assert feed.url == "http://feedjira.com/blog"
  end

  test "parse the feed_url if it does not have the type='application/atom+xml' attribute", %{
    example3: feed
  } do
    assert feed.feed_url == "http://www.innoq.com/planet/atom.xml"
  end

  test "parse the feed_url", %{example2: feed} do
    assert feed.feed_url == "http://aws.typepad.com/aws/atom.xml"
  end

  test "parse feed_url based on rel attribute", %{example5: feed} do
    assert feed.feed_url == "http://feedjira.com/blog/feed.xml"
  end

  test "parse no hub urls", %{example2: feed} do
    assert Enum.count(feed.hubs) == 0
  end

  test "parse the hub urls", %{example4: feed} do
    assert length(feed.hubs) == 1
    assert List.first(feed.hubs) == "http://pubsubhubbub.appspot.com/"
  end

  test "parse updated", %{example1: feed} do
    assert feed.updated == %DateTime{
             day: 13,
             hour: 18,
             minute: 30,
             month: 12,
             second: 2,
             microsecond: {0, 0},
             year: 2003,
             time_zone: "Etc/UTC",
             zone_abbr: "UTC",
             utc_offset: 0,
             std_offset: 0
           }
  end

  test "parse category", %{example1: feed} do
    assert feed.categories == ["vacation", "travel"]
  end

  test "parse contributors", %{example1: feed} do
    assert feed.contributors == ["Jane Doe", "Mr. Smith"]
  end

  test "parse generator", %{example1: feed} do
    assert feed.generator == "http://example.org/atom"
  end

  test "parse icon", %{example1: feed} do
    assert feed.icon == "http://example.org/icon"
  end

  test "parse logo", %{example1: feed} do
    assert feed.logo == "http://example.org/logo"
  end

  test "parse rights", %{example1: feed} do
    assert feed.rights == "MIT License"
  end

  test "parse entries", %{example1: feed} do
    assert Enum.count(feed.entries) == 1
  end

  test "parse complex entries", %{example2: feed} do
    assert Enum.count(feed.entries) == 10
  end

  test "parse complex", %{example6: feed} do
    assert feed.title == "The Verge -  All Posts"
  end
end
