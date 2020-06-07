defmodule Dust.Requests.Result do
  @moduledoc """
  Result struct to store response data
  """
  use TypedStruct
  alias __MODULE__

  @typedoc "Result struct"
  typedstruct do
    field :content, String.t() | nil
    field :full_content, String.t() | nil
    field :size, pos_integer() | 0
    field :status, pos_integer()
    field :duration, pos_integer()
    field :error, HTTPoison.Error.t() | nil
  end

  def from_request({:ok, %HTTPoison.Response{body: content, status_code: status}}, duration) do
    {
      :ok,
      %Result{
        content: content,
        full_content: nil,
        size: byte_size(content),
        status: status,
        duration: duration,
        error: nil
      }
    }
  end

  def from_request({:error, %HTTPoison.Error{reason: reason}}, duration) do
    {
      :error,
      %Result{
        content: nil,
        full_content: nil,
        size: 0,
        status: 0,
        duration: duration,
        error: reason
      }
    }
  end
end
