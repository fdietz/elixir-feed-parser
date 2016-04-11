defmodule ElixirFeedParser.Test.FeedburnerAtomEntryTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.FeedburnerAtom

  setup do
    example1_file = File.read!("test/fixtures/atom/PaulDixExplainsNothing.xml")
    example1 = with {:ok, xml} <- XmlNode.parse_string(example1_file), do: FeedburnerAtom.parse(xml)
    example2_file = File.read!("test/fixtures/atom/PaulDixExplainsNothingAlternate.xml")
    example2 = with {:ok, xml} <- XmlNode.parse_string(example2_file), do: FeedburnerAtom.parse(xml)
    example3_file = File.read!("test/fixtures/atom/FeedBurnerUrlNoAlternate.xml")
    example3 = with {:ok, xml} <- XmlNode.parse_string(example3_file), do: FeedburnerAtom.parse(xml)
    {:ok, [example1: List.first(example1.entries),
        example2: List.first(example2.entries), example3:
        List.first(example3.entries)]}
  end

  test "parse the url using the feed burner origLink element", %{example1: entry} do
    assert entry.url == "http://www.pauldix.net/2009/01/making-a-ruby-c-library-even-faster.html"
  end

  test "parse url via the alternate rel if no feed burner origLink exists", %{example2: entry} do
    assert entry.url == "http://feeds.feedburner.com/~r/PaulDixExplainsNothing/~3/519925023/making-a-ruby-c-library-even-faster.html"
  end

  test "parse url if there is no alternate link", %{example3: entry} do
    assert entry.url == "http://example.com/QQQQ.html"
  end
end
