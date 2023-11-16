defmodule SyntheticManagerWeb.SyntheticLive.FormComponent do
  use SyntheticManagerWeb, :live_component
  alias SyntheticManager.{Repo, Synthetics, Users, Features}


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage synthetic records in your database.</:subtitle>
      </.header>

       <div class="bg-slate-100 shadow-slate-800 shadow-sm p-2 width-full">
            <.input field={@form[:name]} type="text" label="Name" />
          </div>

      <.simple_form
        for={@form}
        id="synthetic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"

      >



          <div class="bg-slate-100 shadow-slate-800 shadow-sm p-2 width-full">
            <.input class="h-60" field={@form[:features]} type="select" options={feature_options(@features)} multiple={true} label="Features" />
          </div>

        <.pretty_user_selector field={@form[:user]} users={available_users()} />

<!--          <.pretty_user_selector target={@myself} form={@form} field={@form[:user]} selected_user={nil} users={available_users()} /> -->

          <div class="bg-slate-100 shadow-slate-800 shadow-sm p-2 width-full">
            <.input field={@form[:description]} type="text" label="Description" />
          </div>

          <div class="bg-slate-100 shadow-slate-800 shadow-sm p-2 width-full">
            <.input field={@form[:hidden_prompt]} type="textarea" label="Hidden Prompt" />
          </div>

          <h1> Messages </h1>
          <div class="bg-slate-100 shadow-slate-800 shadow-sm p-2 width-full">

         <.inputs_for :let={f_nested}  field={@form[:messages]}>
            <.input type="text" field={f_nested[:role]} />
            <.input type="text" field={f_nested[:content]} />
            <.input type="text" field={f_nested[:note]} />
          </.inputs_for>

          <.input type="checkbox" name="add-button" />

      </div>


          <:actions>
            <.button phx-disable-with="Saving...">Save Synthetic</.button>
          </:actions>


      </.simple_form>
    </div>
    """
  end

  def available_users() do
    Users.list_users()
  end

  defp feature_options(features) do
    Enum.map(features, & [key: "#{&1.name} - #{&1.description}", value: &1.id, category: &1.category])
    |> Enum.group_by(& &1[:category])
  end

  @impl true
  def update(%{synthetic: synthetic} = assigns, socket) do
    changeset = Synthetics.change_synthetic(synthetic)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
    }
  end

  @impl true
  def handle_event("select_user", %{"user-id" => id, "synthetic" => attrs}, socket)  do
    uid = id #UUID.string_to_binary!(id)
    attrs = put_in(attrs, [:user], uid)
    changeset = socket.assigns.synthetic
                |> Synthetics.change_synthetic(attrs)
                |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end
  def handle_event("validate", %{"_target" => ["add-button"], "synthetic" => synthetic_params}, socket) do
    changeset =
      socket.assigns.synthetic
      |> Synthetics.change_synthetic(synthetic_params)
      |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end
  def handle_event("validate", %{"synthetic" => synthetic_params}, socket) do
    changeset =
      socket.assigns.synthetic
      |> Synthetics.change_synthetic(synthetic_params)
      |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"synthetic" => synthetic_params}, socket) do
    save_synthetic(socket, socket.assigns.action, synthetic_params)
  end

  defp save_synthetic(socket, :edit, synthetic_params) do
    case Synthetics.update_synthetic(socket.assigns.synthetic, synthetic_params) do
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
    case Synthetics.create_synthetic(synthetic_params) do
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
    form = changeset
           |> to_form()
    socket
    |> assign(:form, form)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
