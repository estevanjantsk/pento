defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    recipient
    |> Recipient.changeset(attrs)
  end

  def send_promo(_recipient, _attrs) do
    :timer.sleep(1000)

    {:ok, %Recipient{}}
  end
end
