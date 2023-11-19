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
    from(e in Synthetic, preload: [:features, :user, :organization, :group]) |> Repo.all()
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
                        v = %Synthetic.Message{} -> v |> IO.inspect(label: "EXISTING")
                        ({_,v}) ->
                          features = Enum.map((v["features"] || v[:features] || []) |> IO.inspect(label: "MESSAGE FEATURES"),
                                       fn
                                         "add-" <> x ->
                                           SyntheticManager.Features.get_feature!(UUID.string_to_binary!(x))
                                           |> case do
                                                x = %{} -> %{id: x.id, category: x.category, name: x.name}
                                                _ -> nil
                                              end
                                         "has-" <> _ ->  nil
                                         x = %{id: _} -> x
                                         x = %{"id" => _} -> x
                                         x = <<uuid::128>> ->
                                           SyntheticManager.Features.get_feature!(x)
                                           |> case do
                                                x = %{} -> %{id: x.id, category: x.category, name: x.name}
                                                _ -> nil
                                              end
                                         x when is_bitstring(x) ->
                                           SyntheticManager.Features.get_feature!(UUID.string_to_binary!(x))
                                           |> case do
                                                x = %{} -> %{id: x.id, category: x.category, name: x.name}
                                                _ -> nil
                                              end
                                         _ -> nil
                                       end
                                     ) |> Enum.reject(&is_nil/1)
                          %{
                            features: features,
                            id: v["id"] || v[:id],
                            role: v["role"] || v[:role],
                            status: v["status"] || v[:status],
                            note: v["note"] || v[:note],
                            content: v["content"] || v[:content],
                            sequence: v["sequence"] || v[:sequence]
                          }
                        v = %{} ->
                          features = Enum.map((v["features"] || v[:features] || []) |> IO.inspect(label: "MESSAGE FEATURES"),
                                       fn
                                         "add-" <> x ->
                                           SyntheticManager.Features.get_feature!(UUID.string_to_binary!(x))
                                           |> case do
                                                x = %{} -> %{id: x.id, category: x.category, name: x.name}
                                                _ -> nil
                                              end
                                         "has-" <> _ ->  nil
                                         x = %{id: _} -> x
                                         x = %{"id" => _} -> x
                                         x = <<uuid::128>> ->
                                           SyntheticManager.Features.get_feature!(x)
                                           |> case do
                                                x = %{} -> %{id: x.id, category: x.category, name: x.name}
                                                _ -> nil
                                              end
                                         x when is_bitstring(x) ->
                                           SyntheticManager.Features.get_feature!(UUID.string_to_binary!(x))
                                           |> case do
                                                x = %{} -> %{id: x.id, category: x.category, name: x.name}
                                                _ -> nil
                                              end
                                         _ -> nil
                                       end
                                     ) |> Enum.reject(&is_nil/1)
                          %{
                            features: features,
                            id: v["id"] || v[:id],
                            role: v["role"] || v[:role],
                            status: v["status"] || v[:status],
                            note: v["note"] || v[:note],
                            content: v["content"] || v[:content],
                            sequence: v["sequence"] || v[:sequence]
                          }
                      end) |> IO.inspect(label: "EMBED MESSAGES")
      change_set
      |> Ecto.Changeset.put_embed(:messages, messages)
    else
      change_set
    end
  end

  def embed_features(change_set, attrs) do
    IO.inspect(change_set, label: "EMBED FEATURES INTO")
    change_set = if uid = (attrs[:user] || attrs["user"]) do
      user = case uid do
        "add-" <> x ->  UUID.string_to_binary!(x) |> SyntheticManager.Users.get_user!()
        x = %{} -> x
        x = <<uuid::128>> -> x |> SyntheticManager.Users.get_user!()
        x when is_bitstring(x) -> UUID.string_to_binary!(x) |> SyntheticManager.Users.get_user!()
        _ -> nil
      end

      change_set
      |> Ecto.Changeset.put_assoc(:user, user)
    else
      change_set
    end

    features = (attrs[:features] || attrs["features"]) |> IO.inspect(label: "FEATURE LIST")
    if is_list(features) && length(features) > 0 do
      features = Enum.map(features,
        fn
          "add-" <> x ->  UUID.string_to_binary!(x)
          "has-" <> _ ->  nil
          %{identifier: x} -> x
          x = <<uuid::128>> -> x
          x when is_bitstring(x) -> UUID.string_to_binary!(x)
        end
      ) |> Enum.reject(&is_nil/1)
      features = Repo.all(from i in Feature, where: i.id in ^features) |> IO.inspect(label: "Features")
      change_set
      |> Ecto.Changeset.put_assoc(:features, features)
    else
      change_set
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
    t = Map.drop(attrs, [:organization, "organization", :user, "user", :features, "features", :messages, "messages"])
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
