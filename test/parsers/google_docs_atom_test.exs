defmodule ElixirFeedParser.Test.GoogleDocsAtomTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.GoogleDocsAtom

  setup do
    example1_file = File.read!("test/fixtures/atom/GoogleDocsList.xml")
    example1 = XmlNode.parse_string(example1_file) |> GoogleDocsAtom.parse
    {:ok, [example1: example1]}
  end

  test "can_parse?" do
    sample_xml = """
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom" xmlns:docs="http://schemas.google.com/docs/2007">
      <title>Example Feed</title>
    </feed>
    """
    xml = XmlNode.parse_string(sample_xml)
    assert GoogleDocsAtom.can_parse?(xml)
  end

  test "parse authors", %{example1: feed} do
    assert feed.authors == ["John Smith"]
  end

  test "parse title", %{example1: feed} do
    assert feed.title == "Available Documents - john.smith.example@gmail.com"
  end
end
