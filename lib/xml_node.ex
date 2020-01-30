defmodule ElixirFeedParser.XmlNode do
  # see https://github.com/erlang/otp/blob/maint/lib/xmerl/include/xmerl.hrl
  # for Record definitions of xmlElement, xmlAttribute, xmlText

  def parse_string(xml_string, options \\ [quiet: true]) do
    try do
      {doc, _misc} = xml_string |> :binary.bin_to_list() |> :xmerl_scan.string(options)
      {:ok, doc}
    catch
      :exit, error ->
        {:error, error}
    end
  end

  def find(node, path) do
    xpath(node, path) |> List.first()
  end

  def map_children(node, selector, callback) do
    node |> children(selector) |> Enum.map(callback)
  end

  def children(node, selector) do
    node |> xpath("./#{selector}")
  end

  def attr(nil, _name), do: nil

  def attr(node, name) do
    node |> xpath("./@#{name}") |> extract_attr
  end

  defp extract_attr(nil), do: nil
  defp extract_attr([]), do: nil

  defp extract_attr([
         {:xmlAttribute, _name, _expanded_name, _nsinfo, _namespace, _parents, _pos, _language,
          value, _normalized}
       ]) do
    List.to_string(value)
  end

  def text(node) do
    node |> xpath("./text()") |> extract_text
  end

  defp extract_text(nil), do: nil
  defp extract_text([]), do: nil

  defp extract_text({:xmlText, _parents, _pos, _language, value, _type}) do
    List.to_string(value)
  end

  defp extract_text([head | tail]) do
    "#{extract_text(head)}#{extract_text(tail)}"
  end

  def xpath(nil, _path), do: nil

  def xpath(node, path) do
    :xmerl_xpath.string(to_char_list(path), node)
  end

  def namespace(nil), do: nil

  def namespace(
        {:xmlElement, _name, _expanded_name, _nsinfo, {:xmlNamespace, default, _nodes}, _parents,
         _pos, _attributes, _content, _language, _xmlbase, _elementdef}
      ) do
    Atom.to_string(default)
  end

  def namespaces(
        {:xmlElement, _name, _expanded_name, _nsinfo, {:xmlNamespace, _default, nodes}, _parents,
         _pos, _attributes, _content, _language, _xmlbase, _elementdef}
      ) do
    result =
      Enum.map(nodes, fn n ->
        {key, value} = n
        {List.to_string(key), Atom.to_string(value)}
      end)

    Enum.into(result, Map.new())
  end

  def element_to_string(node) do
    content = :xmerl.export_simple_element(node, :xmerl_xml)
    List.to_string(content)
  end
end
