defmodule SlackCloudVision.Vision.Client do
  @url "https://vision.googleapis.com/v1/images:annotate"

  def fetch_labels(image_gc_url, max_results \\ 1) do
    %{
      "requests" => [
        %{
          "image" => %{
            "source" => %{"gcs_image_uri" => image_gc_url}
          },
          "features" => [
            %{
              "type" => "LABEL_DETECTION",
              "maxResults" => max_results
            }
          ]
        }
      ]
    }
    |> fetch()
  end

  defp fetch(body) do
    HTTPoison.post!(@url, Poison.encode!(body),
      [{"Content-Type", "application/json"}],
      [params: [key: key]]).body
    |> Poison.decode!
  end

  defp key do
    Application.fetch_env!(:slack_cloud_vision, :api_key)
  end
end
