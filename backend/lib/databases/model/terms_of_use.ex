defmodule Databases.Model.TermsOfUse do
    use Ecto.Schema
    import Ecto.Changeset
    alias Databases.Model
  
    schema "terms_of_use" do
      #field :code, :string
      has_many :terms_of_use_for, Model.DatabaseTermsOfUse 
    end
  
    def remap(%Model.TermsOfUse{} = tou) do
      %{
        id: tou.id,
        #code: tou.code
      }
    end
  
    @doc false
    def changeset(topic, attrs) do
      topic
      |> cast(attrs, [:title])
      |> validate_required([:title])
    end
  end