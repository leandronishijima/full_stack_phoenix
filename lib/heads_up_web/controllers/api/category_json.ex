defmodule HeadsUpWeb.Api.CategoryJSON do
  def show(%{category: category}) do
    %{
      category: %{
        id: category.id,
        name: category.name,
        slug: category.slug,
        incidents:
          for(
            incident <- category.incidents,
            do: %{
              id: incident.id,
              name: incident.name,
              priority: incident.priority,
              status: incident.status,
              description: incident.description
            }
          )
      }
    }
  end
end
