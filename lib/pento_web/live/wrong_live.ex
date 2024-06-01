defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    magic_number = Enum.random(1..10)

    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess",
       time: time(),
       magic_number: magic_number,
       won: false
     )}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    {guess, _} = Integer.parse(guess)

    %{score: score, message: message, won: won} =
      guess_number(%{
        score: socket.assigns.score,
        guess: guess,
        number: socket.assigns.magic_number
      })

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time(),
        won: won
      )
    }
  end

  def handle_event("restart", _params, socket) do
    {
      :noreply,
      assign(
        socket,
        message: "Make a guess",
        score: socket.assigns.score,
        time: time(),
        won: false,
        magic_number: Enum.random(1..10)
      )
    }
  end

  defp guess_number(%{score: score, guess: guess, number: magic_number}) do
    if magic_number == guess do
      %{
        score: score + 1,
        message: "Your guessed thue number: #{guess}.",
        won: true
      }
    else
      %{
        score: score,
        message: "Your guess: #{guess}. Wrong. Guess again.",
        won: false
      }
    end
  end

  defp time() do
    DateTime.utc_now() |> to_string()
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <p><%= @magic_number %></p>
    <h2>
      <%= @message %>
      <span>
        <%= @time %>
      </span>
    </h2>
    <br />
    <div class="flex flex-col gap-2">
      <div class="flex gap-1">
        <%= for n <- 1..10 do %>
          <.link
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded"
            phx-click="guess"
            phx-value-number={n}
          >
            <%= n %>
          </.link>
        <% end %>
      </div>
      <%= if @won do %>
        <div class="flex">
          <.link
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded mt-6"
            phx-click="restart"
          >
            Restart game
          </.link>
        </div>
      <% end %>
    </div>
    """
  end
end
