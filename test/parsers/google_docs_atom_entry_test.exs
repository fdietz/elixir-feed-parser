defmodule ElixirFeedParser.Test.GoogleDocsAtomEntryTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.GoogleDocsAtom

  setup do
    example1_file = File.read!("test/fixtures/atom/GoogleDocsList.xml")
    example1 = with {:ok, xml} <- XmlNode.parse_string(example1_file), do: GoogleDocsAtom.parse(xml)
    {:ok, [example1: List.first(example1.entries)]}
  end

  test "parse authors", %{example1: entry} do
    assert entry.authors == ["Jenna Dolsom"]
  end

  test "parse title", %{example1: entry} do
    assert entry.title == "2010 Income Tax Policy"
  end

  test "parse checksum", %{example1: entry} do
    assert entry.checksum == "2b01142f7481c7b056c4b410d28f33cf"
  end

  test "parse custom filename", %{example1: entry} do
    assert entry.original_filename == "MyFile.pdf"
  end

  test "parse suggested filename", %{example1: entry} do
    assert entry.suggested_filename == "TaxDocument.pdf"
  end
end
