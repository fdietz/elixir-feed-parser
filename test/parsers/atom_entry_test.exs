defmodule ElixirFeedParser.Test.AtomEntryTest do
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
    example6_file = File.read!("test/fixtures/atom/heise.xml")
    example6 = with {:ok, xml} <- XmlNode.parse_string(example6_file), do: Atom.parse(xml)
    {:ok, [example1: List.first(example1.entries), example2:
        List.first(example2.entries), example3: List.first(example3.entries),
        example4: List.first(example4.entries), example5:
        List.first(example5.entries), example6: List.first(example6.entries)]}
  end


  test "parse authors", %{example1: entry} do
    assert entry.authors == ["John Doe", "Ms. Penny"]
  end

  test "parse id", %{example1: entry} do
    assert entry.id == "urn:uuid:1a7532cc-0a6f-44e8-b09f-3c1803d02d78"
  end

  test "parse title", %{example1: entry} do
    assert entry.title == "Example entry title"
  end

  test "parse updated", %{example1: entry} do
    assert entry.updated == %{day: 10, hour: 12, min: 30, month: 10, sec: 0, usec: 0, year: 2015}
  end

  test "parse published", %{example1: entry} do
    assert entry.published == %{day: 9, hour: 12, min: 30, month: 10, sec: 0, usec: 0, year: 2015}
  end

  test "parse summary", %{example1: entry} do
    assert entry.summary == "Example summary"
  end

  test "parse category", %{example1: entry} do
    assert entry.categories == ["vacation", "travel"]
  end

  test "parse contributors", %{example1: entry} do
    assert entry.contributors == ["Jane Doe", "Mr. Smith"]
  end

  test "parse generator", %{example1: entry} do
    assert entry.generator == "http://example.org/atom"
  end

  test "parse rights", %{example1: entry} do
    assert entry.rights == "MIT License"
  end

  test "parse source", %{example1: entry} do
    assert entry.source == "http://example-original.com/entries/1.html"
  end

  test "parse url", %{example2: entry} do
    assert entry.url == "http://aws.typepad.com/aws/2009/01/aws-job-architect-designer-position-in-turkey.html"
  end

  test "parse url if does not have type 'text/html' attribute", %{example3: entry} do
    assert entry.url == "http://www.innoq.com/blog/phaus/2009/07/ja.html"
  end

  test "parse content", %{example1: entry} do
    assert entry.content == "Example content with <a href=\"bla\">link</a><p>my test <em>paragraph</em> is here.</p>"
  end

  test "parse content if xhtml", %{example6: entry} do
    assert Regex.match?(~r/Virtuelle/, entry.content)
  end
end
