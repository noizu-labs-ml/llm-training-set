defmodule SyntheticManagerWeb.SyntheticGroupLive.Index do
  use SyntheticManagerWeb, :live_view

  alias SyntheticManager.SyntheticGroups
  alias SyntheticManager.SyntheticGroups.SyntheticGroup

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :groups, SyntheticGroups.list_groups())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Group")
    |> assign(:group, SyntheticGroups.get_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group")
    |> assign(:group, %SyntheticGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Groups")
    |> assign(:group, nil)
  end

  @impl true
  def handle_info({SyntheticManagerWeb.SyntheticGroupLive.FormComponent, {:saved, group}}, socket) do
    {:noreply, stream_insert(socket, :groups, group)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    group = SyntheticGroups.get_group!(id)
    {:ok, _} = SyntheticGroups.delete_group(group)

    {:noreply, stream_delete(socket, :groups, group)}
  end
end
