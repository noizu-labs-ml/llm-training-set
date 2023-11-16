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


  def fix_messages(synthetic_params) do
    case synthetic_params[:messages] || synthetic_params["messages"] do
      m when is_list(m) or is_map(m) ->
        m = m |> Enum.map(
                   fn
                     v = %Synthetic.Message{} -> v
                     ({_,v}) -> %{ role: v["role"] || v[:role], note: v["note"] || v[:note], content: v["content"] || v[:content], sequence: v["sequence"] || v[:sequence]}
                     v = %{} -> %{ role: v["role"] || v[:role], note: v["note"] || v[:note], content: v["content"] || v[:content], sequence: v["sequence"] || v[:sequence]}
                   end)
        put_in(synthetic_params, [:messages], m)  |> Map.delete("messages")
      _ ->
        synthetic_params
    end
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
    attrs = fix_messages(attrs)
    IO.puts """
    ------------
    Create: #{inspect attrs}

    -------------------------
    """
    t = Map.drop(attrs, [:user, "user", :organization, "organization", :features, "features", :messages, "messages"])
    %Synthetic{}
    |> IO.inspect(label: "Step 1")
    |> Synthetic.changeset(t)
    |> IO.inspect(label: "Step 2")
    |> embed_features(attrs)
    |> IO.inspect(label: "Step 3")
    |> embed_messages(attrs)
    |> IO.inspect(label: "Step 4")
    |> Repo.insert()
    |> IO.inspect(label: "Step 5")
  end

  def embed_messages(change_set, attrs) do
    messages = (attrs[:messages] || attrs["messages"])
    if is_list(messages) && length(messages) > 0 do
      messages = messages
                 |> Enum.map(
                      fn
                        v = %Synthetic.Message{} -> v
                        ({_,v}) ->  %{ role: v["role"] || v[:role], note: v["note"] || v[:note], content: v["content"] || v[:content], sequence: v["sequence"] || v[:sequence]}
                        v = %{} ->  %{ role: v["role"] || v[:role], note: v["note"] || v[:note], content: v["content"] || v[:content], sequence: v["sequence"] || v[:sequence]}
                      end)
      change_set
      |> Ecto.Changeset.put_embed(:messages, messages)
    else
      change_set
    end
  end

  def embed_features(change_set, attrs) do
    change_set2 = if uid = (attrs[:user] || attrs["user"]) do
      user = case uid do
        x = %{} -> x
        x = <<uuid::128>> -> x |> SyntheticManager.Users.get_user!()
        x when is_bitstring(x) -> UUID.string_to_binary!(x) |> SyntheticManager.Users.get_user!()
      end

      change_set
      |> Ecto.Changeset.put_assoc(:user, user)
    else
      change_set
    end

    features = (attrs[:features] || attrs["features"])
    if is_list(features) && length(features) > 0 do
      features = Enum.map(features,
        fn
          %{identifier: x} -> x
          x = <<uuid::128>> -> x
          x when is_bitstring(x) -> UUID.string_to_binary!(x)
        end
      )
      features = Repo.all(from i in Feature, where: i.id in ^features)
      change_set2
      |> Ecto.Changeset.put_assoc(:features, features)
    else
      change_set2
    end
  end

  def fetch_features(ids) do
    ids = Enum.map(ids,
      fn
        %{identifier: <<uuid::128>> = x} -> x
        x = <<uuid::128>> -> x
        x when is_bitstring(x) -> UUID.string_to_binary!(x)
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
    attrs = fix_messages(attrs)
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
    attrs = fix_messages(attrs)
    t = Map.drop(attrs, [:user, "user", :features, "features", :messages, "messages"])
    synthetic
    |> Synthetic.changeset(t)
    |> embed_features(attrs)
    |> embed_messages(attrs)
  end
end
