defmodule HeadsUpWeb.RuleController do
  use HeadsUpWeb, :controller

  alias HeadsUp.Rules

  def index(conn, _params) do
    emojis = ~w(🎉 👀 💼) |> Enum.random() |> String.duplicate(5)
    rules = Rules.list_rules()
    render(conn, :index, emojis: emojis, rules: rules)
  end

  def show(conn, %{"id" => id}) do
    rule = Rules.get_rule(id)

    render(conn, :show, rule: rule)
  end
end
