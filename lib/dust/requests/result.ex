defmodule Dust.Requests.Result do
  @moduledoc """
  Result struct to store response data
  """
  use TypedStruct
  alias __MODULE__

  @typedoc "Result struct"
  typedstruct do
    field :content, String.t(), default: nil
    field :full_content, list(String.t()), default: []
    field :size, pos_integer(), default: 0
    field :status, pos_integer(), default: 0
    field :duration, pos_integer(), default: 0
    field :error, HTTPoison.Error.t(), default: nil
    field :base_url, String.t()
    field :assets, list(Dust.Asset.t()), default: []
  end

  def from_request({:ok, %HTTPoison.Response{body: content, status_code: status, request: request}}, duration) do
    {
      :ok,
      %Result{
        content: content,
        size: byte_size(content),
        status: status,
        duration: duration,
        base_url: request.url
      }
    }
  end

  def from_request({:error, %HTTPoison.Error{reason: reason}}, duration) do
    {
      :error,
      %Result{
        duration: duration,
        error: reason,
      }
    }
  end
end
