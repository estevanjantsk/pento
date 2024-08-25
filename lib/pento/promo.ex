defmodule Pento.Promo do
  alias Pento.Promo.Recipient
  alias Pento.Accounts.UserNotifier

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    recipient
    |> Recipient.changeset(attrs)
  end

  def send_promo(_recipient, attrs) do
    :timer.sleep(1000)

    UserNotifier.deliver_promotion(attrs.email, attrs.first_name)

    {:ok, %Recipient{}}
  end
end
