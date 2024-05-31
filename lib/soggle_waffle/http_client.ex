defmodule SoggyWaffle.HttpClient do
  defstruct [:adapter, :response_handler]

  defmodule Response do
    defstruct [:status_code, :body]
  end

  defmodule StubbedHttpPoison do
    def get(url) do
      send(self(), {__MODULE__, url})

      data = %{hello: :world}
      encoded_body = Jason.encode!(data)
      response = %HTTPoison.Response{status_code: 200, body: encoded_body}
      {:ok, response}
    end
  end

  def create_null(attrs \\ []) do
    default_attrs = %{adapter: StubbedHttpPoison, response_handler: &handle_response/1}
    attrs = Enum.into(attrs, default_attrs)
    struct!(__MODULE__, attrs)
  end

  def create(attrs \\ []) do
    default_attrs = %{adapter: HTTPoison, response_handler: &handle_response/1}
    attrs = Enum.into(attrs, default_attrs)
    struct!(__MODULE__, attrs)
  end

  def get(http_client, url, params) do
    encoded_query = URI.encode_query(params)

    http_client.adapter.get("#{url}?#{encoded_query}")
    |> normalize_result
    |> http_client.response_handler.()
  end

  def normalize_result({:ok, %HTTPoison.Response{status_code: 200} = response}) do
    {:ok, %Response{status_code: response.status_code, body: Jason.decode!(response.body)}}
  end

  def normalize_result({:ok, %HTTPoison.Response{status_code: status_code}}) do
    {:error, {:status, status_code}}
  end

  def normalize_result({:error, reason}) do
    {:error, reason}
  end

  def handle_response(response), do: response
end
