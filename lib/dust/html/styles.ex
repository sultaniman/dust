defmodule Dust.HTML.Styles do
  alias Dust.Asset
  alias Dust.HTML.{Format, Inline}

  @type styles() :: list(binary())

  @task_max_wait_ms 5_000

  @doc """
  Split and prepare each CSS asset and embed
  Base64 encoded images into each stylesheet.
  It needs both image assets and stylesheets
  to lookup references to images in CSS sources
  and replace them with data images.

  Parameters:

    * `assets` list of stylesheets and images `[css: [...], image: [...]]`.

  Returns:

    * `[String.t()]` CSS content with Base64 encoded and embedded images.
  """
  @spec inline([Asset.t()] | keyword()) :: styles()
  def inline(assets) do
    images = Keyword.get(assets, :image, [])
    wait_ms = length(images) * @task_max_wait_ms

    assets
    |> Keyword.get(:css, [])
    |> Enum.map(&async_inline(&1, images))
    |> Enum.map(&Task.await(&1, wait_ms))
  end

  defp async_inline(css, images) do
    Task.async(fn ->
      case css do
        %{result: {:ok, result, _state}} ->
          [
            "<style>",
            "/*", "Style source:", css.relative_url, "*/",
            result.content
            |> Format.split()
            |> Inline.inline(images),
            "</style>"
          ]

        %{result: {:error, _result, _state}} ->
          ["<!--", "Unable to load style:", css.relative_url, "-->"]
      end
    end)
  end
end
