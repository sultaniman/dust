defmodule Dust.HTML.Format do
  @moduledoc false
  def split(content) do
    content
    |> String.split(["\n\n", "\r\n\r\n"], trim: true)
    |> Enum.reject(&blank?/1)
  end

  defp blank?("\r\n" <> rest), do: blank?(rest)
  defp blank?("\n" <> rest), do: blank?(rest)
  defp blank?(" " <> rest), do: blank?(rest)
  defp blank?(""), do: true
  defp blank?(_), do: false
end
