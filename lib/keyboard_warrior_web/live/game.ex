defmodule KeyboardWarriorWeb.Game do
  use Phoenix.LiveView

  alias KeyboardWarriorWeb.GameView

  def render(assigns) do
    GameView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok,
     assign(socket,
       game_status: "Ready!!!",
       random_letter: nil,
       timer: 5,
       points: 0,
       typed: "",
       next: "",
       rest: "",
       display_error: false,
       words_typed: 0
     )}
  end

  def handle_event("type", %{"key" => key}, socket) do
    if key == socket.assigns.next do
      send(self(), :move_cursor)
    else
      send(self(), :display_error)
    end

    {:noreply, socket}
  end

  def handle_event("start_game", _value, socket) do
    send(self(), :timer)
    {:noreply, socket}
  end

  def handle_info(:move_cursor, socket) do
    inc_points = socket.assigns.points + 1
    random_letter = socket.assigns.random_letter
    {typed, to_type} = String.split_at(random_letter, inc_points)

    socket =
      case String.next_codepoint(to_type) do
        {next, rest} ->
          assign(socket,
            next: next,
            rest: rest,
            typed: typed,
            points: inc_points,
            display_error: false
          )

        nil ->
          send(self(), :end_game)
          assign(socket, typed: typed)
      end

    {:noreply, socket}
  end

  def handle_info(:display_error, socket) do
    {:noreply, assign(socket, display_error: true)}
  end

  def handle_info(:end_game, socket) do
    typed = socket.assigns.typed
    rest = socket.assigns.rest

    words_typed =
      case String.next_codepoint(rest) do
        nil -> count_words(typed)
        {" ", _rest} -> count_words(typed)
        _ -> count_words(typed) - 1
      end

    {:noreply, assign(socket, words_typed: words_typed, game_status: "Game Over")}
  end

  def handle_info(:timer, socket) do
    countdown = socket.assigns.timer

    cond do
      countdown == 0 ->
        send(self(), :flash_letter)
        {:noreply, assign(socket, game_status: "Type!", random_letter: get_random())}

      true ->
        Process.send_after(self(), :timer, 1000)

        {:noreply,
         assign(socket, timer: countdown - 1, game_status: "Game starting in #{countdown}")}
    end
  end

  def handle_info(:flash_letter, socket) do
    random_letter = socket.assigns.random_letter
    {typed, to_type} = String.split_at(random_letter, 0)
    {next, rest} = String.next_codepoint(to_type)
    {:noreply, assign(socket, random_letter: random_letter, typed: typed, next: next, rest: rest)}
  end

  defp get_random do
    Faker.Lorem.sentence()
  end

  defp count_words(string) do
    length(String.split(string, " ", trim: true))
  end
end
