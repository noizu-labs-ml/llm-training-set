defmodule SyntheticManager.Synthetics do
  @moduledoc """
  The Synthetics context.
  """

  import Ecto.Query, warn: false
  alias SyntheticManager.Repo

  alias SyntheticManager.Features.Feature
  alias SyntheticManager.Synthetics.SyntheticFeature
  alias SyntheticManager.Synthetics.Synthetic

  @doc """
  Returns the list of synthetics.

  ## Examples

      iex> list_synthetics()
      [%Synthetic{}, ...]

  """
  def list_synthetics do
    from(e in Synthetic, preload: [:features]) |> Repo.all()
  end


  def preload_synthetic(c, :all) do
    c |> Repo.preload([:features, :user, :organization])
  end

  @doc """
  Gets a single synthetic.

  Raises `Ecto.NoResultsError` if the Synthetic does not exist.

  ## Examples

      iex> get_synthetic!(123)
      %Synthetic{details: %{}}

      iex> get_synthetic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_synthetic!(id), do: Repo.get!(Synthetic, id)

  def get_synthetic!(id, :hydrate) do
    Repo.get!(Synthetic, id)
    |> preload_synthetic(:all)
  end
  @doc """
  Creates a synthetic.

  ## Examples

      iex> create_synthetic(%{field: value})
      {:ok, %Synthetic{}}

      iex> create_synthetic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_synthetic(attrs \\ %{}) do
    t = Map.drop(attrs, [:user, "user", :features, "features", :messages, "messages"])
    %Synthetic{}
    |> Synthetic.changeset(t)
    |> embed_features(attrs)
    |> embed_messages(attrs)
    |> Repo.insert()
  end

  def embed_messages(change_set, attrs) do
    if messages = (attrs[:messages] || attrs["messages"]) do
      messages = messages
                 |> Enum.map(
                      fn
                        ({_,v}) -> %{ role: v["role"], note: v["note"], content: v["content"], sequence: v["sequence"]}
                        v = %{} -> v
                      end)
      change_set
      |> Ecto.Changeset.put_embed(:messages, messages)
    else
      change_set
    end
  end

  def embed_features(change_set, attrs) do



    change_set2 = if uid = (attrs[:user] || attrs["user"]) do
      #uid = UUID.binary_to_string!(uid)
      user = SyntheticManager.Users.get_user!(uid) |> IO.inspect(label: "EMBED----------------")
      change_set
      |> Ecto.Changeset.put_assoc(:user, user) |> IO.inspect
    else
      change_set
    end


    if features = (attrs[:features] || attrs["features"]) do
      features = Enum.map(features,
        fn x when is_bitstring(x) -> String.to_integer(x)
          %{identifier: x} -> x
          x when is_integer(x) -> x
        end
      )
      features |> IO.inspect(label: "FEATURE EMBED----------------")
      change_set2
      |> Ecto.Changeset.put_assoc(:features, features)
    else
      change_set2
    end
  end


  def fetch_features(ids) do
    ids = Enum.map(ids,
      fn x when is_bitstring(x) -> String.to_integer(x)
      %{identifier: x} -> x
      x when is_integer(x) -> x
      end
    )
    Repo.all(from i in Feature, where: i.id in ^ids)
  end

  @doc """
  Updates a synthetic.

  ## Examples

      iex> update_synthetic(synthetic, %{field: new_value})
      {:ok, %Synthetic{}}

      iex> update_synthetic(synthetic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_synthetic(%Synthetic{} = synthetic, attrs) do
    t = Map.drop(attrs, [:user, "user", :features, "features", :messages, "messages"])
    synthetic
    |> Synthetic.changeset(t)
    |> embed_features(attrs)
    |> embed_messages(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a synthetic.

  ## Examples

      iex> delete_synthetic(synthetic)
      {:ok, %Synthetic{}}

      iex> delete_synthetic(synthetic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_synthetic(%Synthetic{} = synthetic) do
    Repo.delete(synthetic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking synthetic changes.

  ## Examples

      iex> change_synthetic(synthetic)
      %Ecto.Changeset{data: %Synthetic{}}

  """
  def change_synthetic(%Synthetic{} = synthetic, attrs \\ %{}) do
    t = Map.drop(attrs, [:user, "user", :features, "features", :messages, "messages"])
    synthetic
    |> Synthetic.changeset(t)
    |> embed_features(attrs)
    |> embed_messages(attrs)
  end
end
