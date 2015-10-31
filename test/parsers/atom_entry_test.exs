defmodule ElixirFeedParser.Test.AtomEntryTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom

  setup do
    example1_file = File.read!("test/fixtures/atom/example1.xml")
    example1 = XmlNode.parse_string(example1_file) |> Atom.parse
    example2_file = File.read!("test/fixtures/atom/AmazonWebServicesBlog.xml")
    example2 = XmlNode.parse_string(example2_file) |> Atom.parse
    example3_file = File.read!("test/fixtures/atom/atom_with_link_tag_for_url_unmarked.xml")
    example3 = XmlNode.parse_string(example3_file) |> Atom.parse
    example4_file = File.read!("test/fixtures/atom/SamRuby.xml")
    example4 = XmlNode.parse_string(example4_file) |> Atom.parse
    example5_file = File.read!("test/fixtures/atom/FeedjiraBlog.xml")
    example5 = XmlNode.parse_string(example5_file) |> Atom.parse
    {:ok, [example1: List.first(example1.entries), example2:
        List.first(example2.entries), example3: List.first(example3.entries),
        example4: List.first(example4.entries), example5:
        List.first(example5.entries)]}
  end


  test "parse authors", %{example1: entry} do
    assert ["John Doe", "Ms. Penny"] == entry.authors
  end

  test "parse id", %{example1: entry} do
    assert "urn:uuid:1a7532cc-0a6f-44e8-b09f-3c1803d02d78" == entry.id
  end

  test "parse title", %{example1: entry} do
    assert "Example entry title" == entry.title
  end

  test "parse updated", %{example1: entry} do
    assert "2015-10-10T12:30:00Z" == entry.updated
  end

  test "parse published", %{example1: entry} do
    assert "2015-10-09T12:30:00Z" == entry.published
  end

  test "parse summary", %{example1: entry} do
    assert "Example summary" == entry.summary
  end

  test "parse category", %{example1: entry} do
    assert ["vacation", "travel"] == entry.categories
  end

  test "parse contributors", %{example1: entry} do
    assert ["Jane Doe", "Mr. Smith"] == entry.contributors
  end

  test "parse generator", %{example1: entry} do
    assert "http://example.org/atom" == entry.generator
  end

  test "parse rights", %{example1: entry} do
    assert "MIT License" == entry.rights
  end

  test "parse source", %{example1: entry} do
    assert "http://example-original.com/entries/1.html" == entry.source
  end

  test "parse url", %{example2: entry} do
    assert "http://aws.typepad.com/aws/2009/01/aws-job-architect-designer-position-in-turkey.html" == entry.url
  end

  test "parse url if does not have type 'text/html' attribute", %{example3: entry} do
    assert "http://www.innoq.com/blog/phaus/2009/07/ja.html" ==  entry.url
  end

  test "parse content", %{example1: entry} do
    assert "Example content with <a href=\"bla\">link</a><p>my test <em>paragraph</em> is here.</p>" == entry.content
  end
end
