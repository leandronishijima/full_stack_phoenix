defmodule HeadsUp.Rules do
  def list_rules do
    [
      %{id: 1, text: "Have Fun!"},
      %{id: 2, text: "Winners should dance!"},
      %{id: 3, text: "Losers are losers!"}
    ]
  end

  def get_rule(id) when is_integer(id) do
    Enum.find(list_rules(), fn rule -> rule.id == id end)
  end

  def get_rule(id) when is_binary(id) do
    id |> String.to_integer() |> get_rule()
  end
end
