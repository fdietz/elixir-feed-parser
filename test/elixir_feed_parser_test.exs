defmodule ElixirFeedParserTest do
  use ExUnit.Case

  setup do
    example1 = File.read!("test/fixtures/atom/example1.xml")
    example2 = File.read!("test/fixtures/rss2/example1.xml")
    {:ok, [example1: example1, example2: example2]}
  end

  test "parsing an Atom file", %{example1: example1} do
    result = ElixirFeedParser.parse(example1)
    assert "Example feed title" == result.title
  end

  test "parsing an RSS2 file", %{example2: example2} do
    result = ElixirFeedParser.parse(example2)
    assert "Example feed title" == result.title
  end

  test "parsing an unknown xml string" do
    sample_xml = """
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/unknown_namespace">
      <title>Example Feed</title>
    </feed>
    """
    result = ElixirFeedParser.parse(sample_xml)
    assert {:error, "Feed format unknown"} == result
  end

  # TODO implement me
  # test "parsing an invalid xml string" do
  #   sample_xml = """
  #   <unknown
  #     <titl
  #   </unknown>
  #   """
  #   result = ElixirFeedParser.parse(sample_xml)
  #   assert {:error, "Feed format unknown"} == result
  # end
end
