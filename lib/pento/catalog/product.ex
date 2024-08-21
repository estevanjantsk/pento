defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0)
  end

  def price_decrease_changeset(product, %{"unit_price" => new_price}) do
    product
    |> cast(%{"unit_price" => new_price}, [:unit_price])
    |> validate_change(:unit_price, fn :unit_price, new_price ->
      if new_price < product.unit_price do
        []
      else
        [unit_price: "must be less than the current price"]
      end
    end)
  end
end
