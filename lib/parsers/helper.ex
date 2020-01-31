defmodule ElixirFeedParser.Parsers.Helper do
  alias ElixirFeedParser.XmlNode

  require Logger

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

  def to_date_time(date_time_string), do: to_date_time(date_time_string, "RFC_1123")
  def to_date_time(nil, _), do: nil

  def to_date_time(date_time_string, format) do
    case format do
      "ISO_8601" ->
        {:ok, date_time, _} = DateTime.from_iso8601(date_time_string)
        date_time

      "RFC_1123" ->
        case Timex.parse(date_time_string, "{RFC1123}") do
          {:ok, date_time} ->
            date_time

          _ ->
            Logger.info("WARNING: unparsed date string (#{date_time_string})")
            nil
        end
    end
  end
end
