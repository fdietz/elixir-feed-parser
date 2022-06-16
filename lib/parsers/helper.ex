defmodule ElixirFeedParser.Parsers.Helper do
  alias ElixirFeedParser.XmlNode

  require Logger

  def element(_node, []), do: nil

  def element(node, [selector | other_selectors]) do
    case element(node, selector) do
      nil -> element(node, other_selectors)
      result -> result
    end
  end

  def element(node, selector) do
    node |> XmlNode.find(selector) |> XmlNode.text()
  end

  def element(node, selector, attr: attr) do
    node |> XmlNode.find(selector) |> XmlNode.attr(attr)
  end

  def elements(node, selector) do
    node |> XmlNode.map_children(selector, fn e -> XmlNode.text(e) end)
  end

  def elements(node, selector, attr: attr) do
    node |> XmlNode.map_children(selector, fn e -> XmlNode.attr(e, attr) end)
  end

  def to_date_time(date_time_string), do: to_date_time(date_time_string, ["RFC_1123"])
  def to_date_time(nil, _), do: nil

  def to_date_time(date_time_string, format) when is_binary(format),
    do: to_date_time(date_time_string, [format])

  def to_date_time(date_time_string, []) do
    Logger.info("WARNING: unparsed date string (#{date_time_string})")
    nil
  end

  def to_date_time(date_time_string, ["ISO_8601" | other_formats]) do
    case DateTime.from_iso8601(date_time_string) do
      {:ok, date_time, _} -> date_time
      {:error, _} -> to_date_time(date_time_string, other_formats)
    end
  end

  def to_date_time(date_time_string, ["RFC_1123" | other_formats]) do
    case Timex.parse(date_time_string, "{RFC1123}") do
      {:ok, date_time} -> date_time
      {:error, _} -> to_date_time(date_time_string, other_formats)
    end
  end
end
