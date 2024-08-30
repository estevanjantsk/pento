defmodule Pento.Catalog.Product.Query do
  import Ecto.Query

  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  def base do
    Product
  end

  def preload_user_ratings(query \\ base()) do
    ratings_query =
      Rating.Query.query()
      |> preload([:ratings])
  end
end
