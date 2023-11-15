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

          <div class="bg-slate-100 shadow-slate-800 shadow-sm p-2 width-full">
            <.input field={@form[:name]} type="text" label="Name" />
            <.input field={@form[:created_by]} type="text" label="Created By" />
          </div>


          <div class="bg-slate-100 shadow-slate-800 shadow-sm p-2 width-full">
            <.input class="h-60" field={@form[:features]} type="select" options={feature_options(@features)} multiple={true} label="Features" />
          </div>

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

  defp feature_options(features) do
    Enum.map(features, & [key: "#{&1.name} - #{&1.description}", value: &1.id, category: &1.category])
    |> Enum.group_by(& &1[:category])
  end


  @impl true
  def update(%{synthetic: synthetic} = assigns, socket) do
    changeset = Synthetics.change_synthetic(synthetic)
                |> IO.inspect(label: "1 UPDATE CHANGESET")
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
    }
  end



  @impl true
  def handle_event("validate", %{"_target" => ["add-button"], "synthetic" => synthetic_params}, socket) do
    messages = Enum.map(synthetic_params[:messages] || synthetic_params["messages"] || [],
      fn
        ({_,v}) -> %{ role: v["role"], note: v["note"], content: v["content"], sequence: v["sequence"]}
        v = %{} -> v
      end) |> IO.inspect("CALLED VALIDATE ####################")
    synthetic_params = Map.put(synthetic_params, "messages", messages ++ [%{sequence: :os.system_time(:second), role: "user", content: "", note: ""}])

    changeset =
      socket.assigns.synthetic
      |> Synthetics.change_synthetic(synthetic_params)
      |> Map.put(:action, :append)
      |> tap(& Map.from_struct(&1) |> IO.inspect)
      |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end
  def handle_event("validate", %{"synthetic" => synthetic_params}, socket) do


    messages = Enum.map(synthetic_params[:messages] || synthetic_params["messages"] || [],
      fn
        ({_,v}) -> %{ role: v["role"], note: v["note"], content: v["content"], sequence: v["sequence"]}
        v = %{} -> v
      end) |> IO.inspect("CALLED VALIDATE ####################")
    synthetic_params = Map.put(synthetic_params, "messages", messages)

    changeset =
      socket.assigns.synthetic
      |> Synthetics.change_synthetic(synthetic_params)
      |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end


  def handle_event("save", %{"synthetic" => synthetic_params}, socket) do
    messages = Enum.map(synthetic_params["messages"] || [],
      fn
        ({_,v}) -> %{ role: v["role"], note: v["note"], content: v["content"], sequence: v["sequence"]}
        v = %{} -> v
      end)
    synthetic_params = Map.put(synthetic_params, "messages", messages)

    save_synthetic(socket, socket.assigns.action, synthetic_params)
  end

  defp save_synthetic(socket, :edit, synthetic_params) do
    messages = Enum.map(synthetic_params["messages"] || [],
      fn
        ({_,v}) -> %{ role: v["role"], note: v["note"], content: v["content"], sequence: v["sequence"]}
        v = %{} -> v
      end)
    synthetic_params = Map.put(synthetic_params, "messages", messages)

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

    messages = Enum.map(synthetic_params["messages"] || [],
      fn
        ({_,v}) -> %{ role: v["role"], note: v["note"], content: v["content"], sequence: v["sequence"]}
        v = %{} -> v
      end)
    synthetic_params = Map.put(synthetic_params, "messages", messages)

    case Synthetics.create_synthetic(synthetic_params) |> IO.inspect(label: "SAVE?") do
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

    IO.inspect(form.data, label: "---------------------------")
    socket
    |> assign(:form, form)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
