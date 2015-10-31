defmodule ElixirFeedParser.Test.RSS2EntryTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.RSS2

  setup do
    example1_file = File.read!("test/fixtures/rss2/example1.xml")
    example1 = XmlNode.parse_string(example1_file) |> RSS2.parse
    example2_file = File.read!("test/fixtures/rss2/TenderLoveMaking.xml")
    example2 = XmlNode.parse_string(example2_file) |> RSS2.parse
    {:ok, [example1: List.first(example1.entries), example2: List.first(example2.entries)]}
  end

  test "parse title", %{example2: entry} do
    assert "Nokogiri’s Slop Feature" == entry.title
  end

  test "parse url", %{example2: entry} do
    assert "http://tenderlovemaking.com/2008/12/04/nokogiris-slop-feature/" == entry.url
  end

  test "parse author as dc:creator", %{example2: entry} do
    assert "Aaron Patterson" == entry.author
  end

  test "parse description", %{example2: entry} do
    assert "Oops!  When I released nokogiri version 1.0.7, I totally forgot to talk about Nokogiri::Slop() feature that was added.  Why is it called \"slop\"?  It lets you sloppily explore documents.  Basically, it decorates your document with method_missing() that allows you to search your document via method calls.\nGiven this document:\n\ndoc = Nokogiri::Slop&#40;&#60;&#60;-eohtml&#41;\n&#60;html&#62;\n&#160; &#60;body&#62;\n&#160; [...]" ==  entry.description
  end

  test "parse updated as pubDate", %{example2: entry} do
    assert "Thu, 04 Dec 2008 17:17:49 +0000" == entry.updated
  end

  test "parse guid as id", %{example2: entry} do
    assert "http://tenderlovemaking.com/?p=198" == entry.id
  end

  test "parse categories", %{example2: entry} do
    assert ["computadora", "nokogiri", "rails"] == entry.categories
  end

end
