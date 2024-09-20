defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  use PentoWeb, :chart_live

  alias Pento.Catalog
  alias Contex.Plot

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_age_group_filter()
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  def handle_event(
        "age_group_filter",
        %{"age_group_filter" => age_group_filter},
        socket
      ) do
    {:noreply,
     socket
     |> assign_age_group_filter(age_group_filter)
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  def assign_products_with_average_ratings(
        %{assigns: %{age_group_filter: age_group_filter}} = socket
      ) do
    socket
    |> assign(
      :products_with_average_ratings,
      get_products_with_average_ratings(%{
        age_group_filter: age_group_filter,
        gender_filter: "all"
      })
    )
  end

  defp get_products_with_average_ratings(filters) do
    case Catalog.products_with_average_ratings(filters) do
      [] ->
        Catalog.products_with_zero_ratings()

      products ->
        products
    end
  end

  def assign_dataset(
        %{
          assigns: %{products_with_average_ratings: products_with_average_ratings}
        } = socket
      ) do
    socket
    |> assign(:dataset, make_bar_chart_dataset(products_with_average_ratings))
  end

  def assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  def assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(
      :chart_svg,
      render_bar_chart(chart, title(), subtitle(), x_axis(), y_axis())
    )
  end

  def assign_age_group_filter(socket) do
    assign(socket, :age_group_filter, "all")
  end

  def assign_age_group_filter(socket, age_group_filter) do
    assign(socket, :age_group_filter, age_group_filter)
  end

  defp title do
    "Survey Results"
  end

  defp subtitle do
    "Average star ratings for products"
  end

  defp x_axis do
    "product"
  end

  defp y_axis do
    "stars"
  end
end
