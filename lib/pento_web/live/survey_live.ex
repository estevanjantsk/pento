defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.DemographicLive
  alias Pento.Survey

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> IO.inspect() |> assign_demographic()}
  end

  @impl true
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, demographic: Survey.get_demographic_by_user(current_user))
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end
end
