defmodule HeadsUp.Responses.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :note, :string
    field :status, Ecto.Enum, values: [:enroute, :arrived, :departed]

    belongs_to :user, HeadsUp.Accounts.User
    belongs_to :incident, HeadsUp.Incidents.Incident

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:note, :status])
    |> validate_required([:status])
    |> validate_length(:note, max: 500)
    |> validate_inclusion(:status, [:enroute, :arrived, :departed])
    |> assoc_constraint(:user)
    |> assoc_constraint(:incident)
  end
end
