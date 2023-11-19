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
      <.simple_form
        for={@form}
        id="synthetic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"

      >


      <fieldset class=" " >
        <!-- Form:Name -->
        <.tailwind_input
          field={@form[:name]}
          placeholder="feature-coverage-1"
        >
          <:add_on>
          Name
          </:add_on>
        </.tailwind_input>

        <!-- Form:Status -->
        <.tailwind_input
                    field={@form[:status]}
                    options={statuses()}
                    hidden_label="Select Role"
                    type="select"
            >
              <:add_on>Status</:add_on>
            </.tailwind_input>

        <!-- Form:Description -->
        <.tailwind_input
          field={@form[:description]}
          placeholder="describe this data set"
        >
          <:add_on>
          Description
          </:add_on>
        </.tailwind_input>

        <!-- Form:User -->
        <.tailwind_input
          field={@form[:user]}
          type="search"
          phx-target={@myself}
          search={assigns[:user_filter_term] || ""}
          options={@user_filter}
          hidden_label="Select User"
          hint="Required"
        >
          <:display_option :let={%{id: id, option: option}} >
            Name: <%= option.name %>
          </:display_option>
        </.tailwind_input>

        <!-- Form:Features -->
        <.tailwind_input
          field={@form[:features]}
          type="search"
          multiple
          phx-target={@myself}
          search={assigns[:feature_filter_term] || ""}
          options={@feature_filter}
          hidden_label="Select Features"
          hint="Required"
          description="Features Covered By This DataSet"
        >
          <:display_option :let={%{id: id, option: option}} >
          <%= option.category %> - <%= option.name %>
          </:display_option>
        </.tailwind_input>

        <!-- Form:Hidden Prompt -->
        <.tailwind_input
          field={@form[:hidden_prompt]}
          type="textarea" label="Hidden Prompt" hint="Optional"
          description="Hidden prompt used when building interactively but not included in data sent to fine tuner."
          placeholder="..."
        />


    <div class="border p-2">

          <h1> Messages </h1>



         <.inputs_for :let={f_nested}  field={@form[:messages]}>
          <% inspect f_nested %>
          <div class=" p-2 border width-full">
            <.input type="hidden" field={f_nested[:id]} />
            <.input type="hidden" field={f_nested[:_persistent_id]} />
            <.tailwind_input
                    field={f_nested[:role]}
                    options={roles()}
                    hidden_label="Select Role"
                    type="select"
            >
              <:add_on>Role</:add_on>
            </.tailwind_input>
            <.tailwind_input
                    field={f_nested[:status]}
                    options={statuses()}
                    hidden_label="Select Status"
                    type="select"
            >
              <:add_on>Status</:add_on>
            </.tailwind_input>

         <.tailwind_input
          field={f_nested[:features]}
          type="search"
          multiple
          phx-target={@myself}
          search={assigns[:feature_filter_term] || ""}
          options={@feature_filter}
          hidden_label="Select Features"
          hint="Required"
          description="Features Covered By This DataSet"
        >
          <:display_option :let={%{id: id, option: option}} >
          <%= option.category %> - <%= option.name %>
          </:display_option>
        </.tailwind_input>

            <.tailwind_input
                    field={f_nested[:note]}
                    type="text"

             >
              <:add_on>Note</:add_on>
            </.tailwind_input>
            <.tailwind_input
                    field={f_nested[:content]}
                    type="textarea"
                    placeholder="Content"
                    label="Content"
             />

          </div>
          </.inputs_for>

          <.input type="checkbox" class="mt-8" name="add-button" label="Add" />


        </div>

      </fieldset>






      <:actions>
        <.button phx-disable-with="Saving...">Save Synthetic</.button>
      </:actions>


      </.simple_form>
    </div>
    """
  end

  def roles() do
    SyntheticManager.MessageRoleEnum.values()
    |> Enum.map(& %{value: &1, key: &1})
  end
  def statuses() do
    SyntheticManager.EntityStatusEnum.values()
    |> Enum.map(& %{value: &1, key: &1})
  end

  def available_users() do
    Users.list_users()
  end

  defp feature_options(features) do
    Enum.map(features, & [key: &1, value: &1.id, category: &1.category])
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


  def fix_messages(synthetic_params, socket) do
    changeset = socket.assigns.synthetic

    case synthetic_params[:messages] || synthetic_params["messages"] do
      m when is_list(m) or is_map(m) ->
        messages = socket.assigns.form[:messages].value
                   |> Enum.map(
                        fn
                          %Ecto.Changeset{data: y} ->
                            y
                          x -> x
                        end)
        |> IO.inspect(label: "SYNTHETICS")
        IO.inspect(m, label: "INPUT")
        m = m |> Enum.map(
                   fn
                     ({_,v}) -> v
                     v = %{} -> v
                   end
                 )
            |> Enum.map(fn(v) ->
          IO.inspect(v, label: "MESSAGE CHANGE")
          # id
          id = v["id"] || v[:id]
          per_id = v["_persistent_id"] || v[:_persistent_id]
          # Role
          role = v["role"] || v[:role] || :unknown
          role = Enum.find_value(SyntheticManager.MessageRoleEnum.values(), :unknown, & (&1 == role || "#{&1}" == role) && &1 )
          IO.inspect(role, label: "ROLE [#{inspect v["role"]}] - [#{inspect v[:role]}] = ")
          # Status
          status = v["status"] || v[:status] || :unknown
          status = Enum.find_value(SyntheticManager.EntityStatusEnum.values(), :unknown, & (&1 == status || "#{&1}" == status) && &1 )
          IO.inspect(status, label: "STATUS [#{inspect v["status"]}] - [#{inspect v[:status]}] = ")

          features = Enum.map(v["features"] || v[:features] || [],
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
                       end
                     ) |> Enum.reject(&is_nil/1)
                       |> Enum.uniq_by(& &1["id"] || &1[:id])
          |> IO.inspect(label: "MESSAGE FEATURE")

          # Update
          source = case Enum.find_value(messages, & &1.id == id && &1) do
            x = %{id: id} ->
              Map.from_struct(x)
              |> update_in([Access.key(:role)], & role || &1)
              |> update_in([Access.key(:features)], & features || &1)
              |> update_in([Access.key(:status)], & status || &1)
              |> update_in([Access.key(:note)], & v["note"] || v[:note] || &1)
              |> update_in([Access.key(:content)], & v["content"] || v[:content] || &1)
              |> update_in([Access.key(:sequence)], & v["sequence"] || v[:sequence] || &1)
            _ ->
              %{}
              |> update_in([Access.key(:role)], & role || &1)
              |> update_in([Access.key(:features)], & features || &1)
              |> update_in([Access.key(:status)], & status || &1)
              |> update_in([Access.key(:note)], & v["note"] || v[:note] || &1)
              |> update_in([Access.key(:content)], & v["content"] || v[:content] || &1)
              |> update_in([Access.key(:sequence)], & v["sequence"] || v[:sequence] || &1)
          end |> IO.inspect(label: "MESSAGE UPDATE")

        end)
        put_in(synthetic_params, [:messages], m)  |> Map.delete("messages")
      _ ->
        synthetic_params
    end
  end

  def handle_event("search", params = %{ "select-synthetic" => %{"features" => filter}}, socket) do
    search = Features.filter_features(filter) |> IO.inspect(label: "Filtered By #{filter}")
             |> Enum.map(& %{value: &1.id, key: &1})
             |> Enum.group_by(& &1.key.category)
    {:noreply,
      socket
      |> assign(:feature_filter_term, filter)
      |> assign(:feature_filter, search)
    }
  end

  def handle_event("search", params = %{ "select-synthetic" => %{"user" => filter}}, socket) do
    search = Users.filter_users(%{name: filter}) |> IO.inspect(label: "Filtered By #{filter}")
             |> Enum.map(& %{value: &1.id, key: &1})
    {:noreply,
      socket
      |> assign(:user_filter_term, filter)
      |> assign(:user_filter, search)
    }
  end

  @impl true
  def handle_event("validate", %{"_target" => ["add-button"], "synthetic" => synthetic_params}, socket) do
    synthetic_params = fix_messages(synthetic_params, socket)
    p = synthetic_params[:messages] || []
    p = p ++ [%{status: :unknown, role: :unknown, sequence: :os.system_time(:second)}]
    synthetic_params = Map.put(synthetic_params, :messages, p)

    changeset =
      socket.assigns.synthetic
      |> Synthetics.change_synthetic(synthetic_params)
      |> Map.put(:action, :append)
      |> Map.put(:action, :validate)
    {:noreply,
      assign_form(socket, changeset)
    }
  end


  def handle_event("validate", %{"synthetic" => synthetic_params} = params, socket) do
    synthetic_params = cond do
        x = params["edit-synthetic"]["user"] ->
          case synthetic_params["user"]  do
            %{id: ^x} -> synthetic_params
            %{data: %{id: ^x}} -> synthetic_params
            _ -> put_in(synthetic_params, [Access.key("user")], x)
          end
        :else -> synthetic_params
    end

    synthetic_params = fix_messages(synthetic_params, socket)

    changeset =
      socket.assigns.synthetic
      |> Synthetics.change_synthetic(synthetic_params)
      |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"synthetic" => synthetic_params} = params, socket) do

    synthetic_params = cond do
      x = params["edit-synthetic"]["user"] ->
        case synthetic_params["user"]  do
          %{id: ^x} -> synthetic_params
          %{data: %{id: ^x}} -> synthetic_params
          _ -> put_in(synthetic_params, [Access.key("user")], x)
        end
      :else -> synthetic_params
    end

    synthetic_params = fix_messages(synthetic_params, socket)
    save_synthetic(socket, socket.assigns.action, synthetic_params)
  end


  defp save_synthetic(socket, :modify, synthetic_params) do
    synthetic_params = fix_messages(synthetic_params, socket)
    case socket.assigns[:synthetic] do
      %{id: nil} ->
        case Synthetics.create_synthetic(synthetic_params) |> IO.inspect do
          {:ok, synthetic} ->
            notify_parent({:modified, synthetic})
            {:noreply, socket}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign_form(socket, changeset)}
        end
        nil -> case Synthetics.create_synthetic(synthetic_params) |> IO.inspect do
                 {:ok, synthetic} ->
                   notify_parent({:modified, synthetic})
                   {:noreply, socket}

                 {:error, %Ecto.Changeset{} = changeset} ->
                   {:noreply, assign_form(socket, changeset)}
               end
      synthetic = %{} ->
        case Synthetics.update_synthetic(synthetic, synthetic_params) |> IO.inspect do
          {:ok, synthetic} ->
            notify_parent({:modified, synthetic})
            {:noreply, socket}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign_form(socket, changeset)}
        end
    end


  end

  defp save_synthetic(socket, :edit, synthetic_params) do
    IO.puts """
    ===========================================================
    SAVE
    params: #{inspect synthetic_params}
    ===========================================================
    """
    case Synthetics.update_synthetic(socket.assigns.synthetic, synthetic_params) |> IO.inspect do
      {:ok, synthetic} ->
        notify_parent({:saved, synthetic})

        if socket.assigns.patch do
          {:noreply,
            socket
            |> put_flash(:info, "Synthetic updated successfully")
            |> push_patch(to: socket.assigns.patch)}
        else
          js = hide_modal("synthetic-upload-modal")
          {:noreply,
            socket
            |> put_flash(:info, "Synthetic updated successfully")
            |> push_event("js_push", %{js: js.ops})
          }
        end


      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end


  defp save_synthetic(socket, :new, synthetic_params) do
    synthetic_params = fix_messages(synthetic_params, socket)
    case Synthetics.create_synthetic(synthetic_params) do
      {:ok, synthetic} ->
        notify_parent({:saved, synthetic})

        if socket.assigns.patch do
          {:noreply,
            socket
            |> put_flash(:info, "Synthetic created successfully")
            |> push_patch(to: socket.assigns.patch)}
        else
          js = hide_modal("synthetic-upload-modal")
          {:noreply,
            socket
            |> put_flash(:info, "Synthetic created successfully")
            |> push_event("js_push", %{js: js.ops})
          }
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = changeset
           |> to_form()
           |> IO.inspect
    socket
    |> assign(:form, form)
    |> assign(:feature_filter, socket.assigns[:feature_filter] ||
      Features.list_features()
      |> Enum.map(& %{value: &1.id, key: &1})
      |> Enum.group_by(& &1.key.category)
       )
    |> assign(:user_filter, socket.assigns[:user_filter] || [])
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
