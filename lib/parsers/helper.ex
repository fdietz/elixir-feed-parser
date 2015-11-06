defmodule ElixirFeedParser.Parsers.Helper do
  alias ElixirFeedParser.XmlNode

  def element(node, selector) do
    node |> XmlNode.find(selector) |> XmlNode.text
  end

  def element(node, selector, [attr: attr]) do
    node |> XmlNode.find(selector) |> XmlNode.attr(attr)
  end

  def elements(node, selector) do
    node |> XmlNode.map_children(selector, fn(e) -> XmlNode.text(e) end)
  end

  def elements(node, selector, [attr: attr]) do
    node |> XmlNode.map_children(selector, fn(e) -> XmlNode.attr(e, attr) end)
  end

  def to_date_time(date_time_string), do: to_date_time(date_time_string, "{RFC1123}")
  def to_date_time(nil, _), do: nil
  def to_date_time(date_time_string, format) do
    case Timex.DateFormat.parse(date_time_string, format) do
      {:ok, date} -> date |> Timex.Date.universal |> timex_date_time_to_map
      _ -> nil
    end
  end

  defp timex_date_time_to_map(timex_date_time) do
    %{
      year: timex_date_time.year, month: timex_date_time.month, day: timex_date_time.day,
      hour: timex_date_time.hour, min: timex_date_time.minute, sec: timex_date_time.second, usec: timex_date_time.ms
    }
  end
end
