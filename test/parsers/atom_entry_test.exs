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
    example6_file = File.read!("test/fixtures/atom/PaulDixExplainsNothing.xml")
    example6 = XmlNode.parse_string(example6_file) |> Atom.parse
    example7_file = File.read!("test/fixtures/atom/PaulDixExplainsNothingAlternate.xml")
    example7 = XmlNode.parse_string(example7_file) |> Atom.parse
    example8_file = File.read!("test/fixtures/atom/FeedBurnerUrlNoAlternate.xml")
    example8 = XmlNode.parse_string(example8_file) |> Atom.parse
    {:ok, [example1: List.first(example1.entries), example2:
        List.first(example2.entries), example3: List.first(example3.entries),
        example4: List.first(example4.entries), example5:
        List.first(example5.entries), example6: List.first(example6.entries),
        example7: List.first(example7.entries), example8:
        List.first(example8.entries)]}
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
    assert entry.updated == "2015-10-10T12:30:00Z"
  end

  test "parse published", %{example1: entry} do
    assert entry.published == "2015-10-09T12:30:00Z"
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

  test "parse the url using the feed burner origLink element", %{example6: entry} do
    assert entry.url == "http://www.pauldix.net/2009/01/making-a-ruby-c-library-even-faster.html"
  end

  test "parse url via the alternate rel if no feed burner origLink exists", %{example7: entry} do
    assert entry.url == "http://feeds.feedburner.com/~r/PaulDixExplainsNothing/~3/519925023/making-a-ruby-c-library-even-faster.html"
  end

  test "parse url if there is no alternate link", %{example8: entry} do
    assert entry.url == "http://example.com/QQQQ.html"
  end
end
