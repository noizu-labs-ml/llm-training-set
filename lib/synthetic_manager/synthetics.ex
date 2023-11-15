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
    |> Repo.preload([:features])
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

    t = Map.delete(attrs, "features")
        |> Map.delete(:features)
        |> Map.delete("messages")
        |> Map.delete(:messages)

    messages = Enum.map(
      attrs[:messages] || attrs["messages"] || [],
      & %Synthetic.Message{
        id: &1["id"] || &1[:id],
        role: &1["role"] || &1[:role],
        note: &1["note"] || &1[:note],
        content: &1["content"] || &1[:content],
        sequence: (&1["sequence"] || &1[:sequence] || 0),
      } )

    %Synthetic{}
    |> Synthetic.changeset(t)
    |> Ecto.Changeset.put_assoc(:features, fetch_features(attrs[:features] || attrs["features"] || []))
    |> Ecto.Changeset.put_embed(:messages, messages)
    |> tap(& &1.data |> IO.inspect(label: :create))
    |> Repo.insert()
    |> IO.inspect(label: :create)
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

    t = Map.delete(attrs, "features")
        |> Map.delete(:features)
        |> Map.delete("messages")
        |> Map.delete(:messages)

    messages = Enum.map(
      attrs[:messages] || attrs["messages"] || [],
      & %Synthetic.Message{
        id: &1["id"] || &1[:id],
        role: &1["role"] || &1[:role],
        note: &1["note"] || &1[:note],
        content: &1["content"] || &1[:content],
        sequence: (&1["sequence"] || &1[:sequence] || 0),
      } )


    synthetic
    |> Synthetic.changeset(t)
    |> Ecto.Changeset.put_assoc(:features, fetch_features(attrs[:features] || attrs["features"] || []))
    |> Ecto.Changeset.put_embed(:messages, messages)
    |> tap(& &1.data |> IO.inspect(label: :create))
    |> Repo.update()
    |> IO.inspect(label: "UPDATE OUTCOME")
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
    t = Map.delete(attrs, "features")
        |> Map.delete(:features)
        |> Map.delete("messages")
        |> Map.delete(:messages)

    messages = Enum.map(
      attrs[:messages] || attrs["messages"] || [],
      & %Synthetic.Message{
        id: &1["id"] || &1[:id],
        role: &1["role"] || &1[:role],
        note: &1["note"] || &1[:note],
        content: &1["content"] || &1[:content],
        sequence: (&1["sequence"] || &1[:sequence] || 0),
      } )


    if attrs["messages"] || attrs[:message] do
      Synthetic.changeset(synthetic, t)
      |> Ecto.Changeset.put_assoc(:features, fetch_features(attrs[:features] || attrs["features"] || []))
      |> Ecto.Changeset.put_embed(:messages, messages)
      else
      Synthetic.changeset(synthetic, t)
      |> Ecto.Changeset.put_assoc(:features, fetch_features(attrs[:features] || attrs["features"] || []))

    end

    #|> cast_embed(:messages, with: &message_changeset/2)
  end
end
