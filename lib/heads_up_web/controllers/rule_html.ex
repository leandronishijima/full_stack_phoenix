defmodule HeadsUpWeb.RuleHTML do
  use HeadsUpWeb, :html

  embed_templates "rules_html/*"

  def show(assigns) do
    ~H"""
    <div>
      <h1>Dont forget...</h1>
      <p>
        <%= @rule.text %>
      </p>
    </div>
    """
  end
end
