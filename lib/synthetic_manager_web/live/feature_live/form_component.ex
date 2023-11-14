defmodule SyntheticManagerWeb.FeatureLive.FormComponent do
  use SyntheticManagerWeb, :live_component

  alias SyntheticManager.Features


  def category_options() do
    [
      basic_syntax: "basic_syntax",
      code_block: "code_block",
      prompt_prefix: "prompt_prefix",
      directive: "directive",
      agent: "agent",
      runtime_flag: "runtime_flag",
      other:  "other",

    ]
  end
  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage feature records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="feature-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:category]} options={category_options()} type="select" label="Category" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Feature</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{feature: feature} = assigns, socket) do
    changeset = Features.change_feature(feature)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"feature" => feature_params}, socket) do
    changeset =
      socket.assigns.feature
      |> Features.change_feature(feature_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"feature" => feature_params}, socket) do
    save_feature(socket, socket.assigns.action, feature_params)
  end

  defp save_feature(socket, :edit, feature_params) do
    case Features.update_feature(socket.assigns.feature, feature_params) do
      {:ok, feature} ->
        notify_parent({:saved, feature})

        {:noreply,
         socket
         |> put_flash(:info, "Feature updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_feature(socket, :new, feature_params) do
    case Features.create_feature(feature_params) do
      {:ok, feature} ->
        notify_parent({:saved, feature})

        {:noreply,
         socket
         |> put_flash(:info, "Feature created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
