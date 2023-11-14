defmodule SyntheticManagerWeb.SyntheticLive.FormComponent do
  use SyntheticManagerWeb, :live_component

  alias SyntheticManager.Synthetics
  alias SyntheticManager.Features


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage synthetic records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="synthetic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:created_by]} type="text" label="Created By" />


        <.input field={@form[:feature_list]} type="select" options={@feature_options} multiple={true} label="Features" />
        <.input field={@form[:description]} type="text" label="Description" />

        <.input field={@form[:hidden_prompt]} type="textarea" label="Hidden Prompt" />

        [ Messages}

        <:actions>
          <.button phx-disable-with="Saving...">Save Synthetic</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{synthetic: synthetic} = assigns, socket) do
    IO.puts "UPDATE"
    features = synthetic.features
               |> Enum.map(& &1.id)
    params = %{features: features}
    IO.inspect(synthetic, label: "SYNTHETIC")
    changeset = Synthetics.change_synthetic(synthetic, params)
                |> IO.inspect(label: "UDPATE CHANGESET")
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"synthetic" => synthetic_params}, socket) do
    features = synthetic_params["feature_list"]
               |> Enum.map(&String.to_integer/1)

    tweak = Map.put(synthetic_params, "features", features)
    changeset =
      socket.assigns.synthetic
      |> Synthetics.change_synthetic(tweak)
      |> put_in([Access.key(:data), Access.key(:feature_list)], synthetic_params["feature_list"] || [])
      |> Map.put(:action, :validate)

    IO.inspect changeset, label: "VALIDATE"
#      |> update_in([Access.key(:data), Access.key(:features)], fn(x) ->
#          Enum.map(x, & "#{&1.id}")
#      end)
#
#      changeset.data |> IO.inspect(label: "AFTER CHANGE!!!!!!!!!!!!!!")

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"synthetic" => synthetic_params}, socket) do
    IO.puts "SAVE"
    save_synthetic(socket, socket.assigns.action, synthetic_params)
  end

  defp save_synthetic(socket, :edit, synthetic_params) do
    IO.inspect(synthetic_params, label: "SAVE !")
    features = synthetic_params["feature_list"]
               |> Enum.map(&String.to_integer/1)

    tweak = Map.put(synthetic_params, "features", features)
    case Synthetics.update_synthetic(socket.assigns.synthetic, tweak) do
      {:ok, synthetic} ->
        notify_parent({:saved, synthetic})

        {:noreply,
         socket
         |> put_flash(:info, "Synthetic updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_synthetic(socket, :new, synthetic_params) do
    case Synthetics.create_synthetic(synthetic_params) |> IO.inspect() do
      {:ok, synthetic} ->
        notify_parent({:saved, synthetic})

        {:noreply,
         socket
         |> put_flash(:info, "Synthetic created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    features = Enum.map(changeset.data.features, & "#{&1.id}")
    form = changeset
           |> put_in([Access.key(:data), Access.key(:feature_list)], features)
           |> to_form()
           |> IO.inspect(label: "ASSIGN")
    socket
    |> assign(:form, form)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
