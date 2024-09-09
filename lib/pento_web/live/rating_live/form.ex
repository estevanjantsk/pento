defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Rating

  import PentoWeb.CoreComponents

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rating()
     |> clear_form()}
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, socket}
  end

  def assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    assign(socket, :rating, %Rating{user_id: user.id, product_id: product.id})
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def clear_form(%{assigns: %{rating: rating}} = socket) do
    assign_form(socket, Survey.change_rating(rating))
  end
end
