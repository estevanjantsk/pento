defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> clear_form()}
  end

  @impl true
  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      Promo.change_recipient(recipient, recipient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    {:ok, _recipient} = Promo.send_promo(%Recipient{}, recipient_params)

    socket =
      socket |> assign_recipient |> clear_form() |> put_flash(:info, "Promo sent successfully")

    {:noreply, socket}
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def clear_form(socket) do
    form =
      socket.assigns.recipient
      |> Promo.change_recipient()
      |> to_form()

    assign(socket, form: form)
  end

  def assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset))
  end
end
