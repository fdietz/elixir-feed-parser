defmodule ElixirFeedParserTest do
  use ExUnit.Case

  setup do
    example1 = File.read!("test/fixtures/atom/example1.xml")
    example2 = File.read!("test/fixtures/rss2/example1.xml")
    example3 = File.read!("test/fixtures/atom/GoogleDocsList.xml")
    example4 = File.read!("test/fixtures/rss2/itunes.xml")
    {:ok, [example1: example1, example2: example2, example3: example3, example4: example4]}
  end

  test "parsing an Atom file", %{example1: example1} do
    result = ElixirFeedParser.parse(example1)
    assert "Example feed title" == result.title
  end

  test "parsing an RSS2 file", %{example2: example2} do
    result = ElixirFeedParser.parse(example2)
    assert "Example feed title" == result.title
  end

  test "parsing an Google Docs Atom file", %{example3: example3} do
    result = ElixirFeedParser.parse(example3)
    assert "Available Documents - john.smith.example@gmail.com" == result.title
  end

  test "parsing an iTunes RSS2 file", %{example4: example4} do
    result = ElixirFeedParser.parse(example4)
    assert "All About Everything" == result.title
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

end
