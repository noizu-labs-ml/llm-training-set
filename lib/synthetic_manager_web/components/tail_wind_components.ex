defmodule SyntheticManagerWeb.TailWindComponents do
  @moduledoc """
  Tailwind UI Elixir Components
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import SyntheticManagerWeb.Gettext
  import SyntheticManagerWeb.CoreComponents

  @doc """
  # More Interactive and extensible UI components than provided by LiveView Sock
  #
  """
  attr :id, :any, default: nil, doc: "Component HTML id"
  attr :name, :any, doc: "Component HTML Form Name"
  attr :hint, :string, default: nil, doc: "Input Hint Like Optional"
  attr :label, :string, default: nil, doc: "Input Label"
  attr :hidden_label, :string, default: nil, doc: "Hidden SR-Only Input Label"
  attr :description, :string, default: nil, doc: "Input Description, shown under input"
  slot :add_on, required: false do
    attr :inline, :boolean, doc: "Is Inline"
  end
  attr :search, :any, default: nil, required: false
  slot :right_add_on, required: false do
    attr :inline, :boolean, doc: "Is Inline"
  end
  attr :value, :any, doc: "Current value of input"
  attr :type, :string,
       default: "text",
       values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)
  attr :field, Phoenix.HTML.FormField,
       doc: "a form field struct retrieved from the form, for example: @form[:email]"
  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :class, :string, default: ""
  attr :rows, :integer, default: 4
  attr :rest, :global,
       include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)
  slot :inner_block
  slot :display_option, required: false
  slot :selected_option, required: false
  def tailwind_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    IO.inspect(field.errors)
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.type == "select" && assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn ->
      case field.value do
      %Ecto.Association.NotLoaded{} -> nil
      value -> value
      end |> IO.inspect(label: "#{field.name} - VALUE")
    end)
    |> tailwind_input()
  end

  def tailwind_input(%{type: type} = assigns)  when type in ["text", "password", "email"] do
    ~H"""
    <div phx-feedback-for={@name} class="tailwind-input">
      <div class="flex justify-between">
        <label :if={@label && @label != ""} for="{@id}" class="block text-sm font-medium leading-6 text-gray-900"><%= @label %></label>
        <label :if={@hidden_label && @hidden_label != ""} for="{@id}" class="sr-only"><%= @hidden_label %></label>
        <span :if={@hint && @hint != ""} class="text-sm leading-6 text-gray-500" id={"#{@id}-input-hint"}><%= @hint %></span>
      </div>
      <div class={"input-wrapper #{@type}"}>

       <span
        :for={x <- @add_on}
        class={["add-on", x[:inline] &&  "inline"]}
        ><%= render_slot(x, @id) %></span>


        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
             "text-input",
             @add_on != [] && "add-on",
             @right_add_on != [] && "right-add-on",
             @errors != [] && "clean" || "error",
          ]}
          aria-describedby={@description && "#{@id}-input-description"}
          {@rest}
        />

       <span
        :for={x <- @right_add_on}
        class={["right-add-on", x[:inline] &&  "inline"]}
       ><%= render_slot(x, @id) %></span>

        <span :if={@errors != []} class="right-add-on inline">
          <svg class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
          </svg>
        </span>

      </div>
      <p :if={@description && @description != ""}
          class={[
            "input-description",
            @errors == [] && "clean" || "error"
          ]}
          id={"#{@id}-input-description"}><%= @description %></p>
    </div>
     """
  end

  def tailwind_input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="tailwind-input">
     <div class="flex justify-between">
       <label :if={@label && @label != ""} for="{@id}" class="block text-sm font-medium leading-6 text-gray-900"><%= @label %></label>
       <label :if={@hidden_label && @hidden_label != ""} for="{@id}" class="sr-only"><%= @hidden_label %></label>
       <span :if={@hint && @hint != ""} class="text-sm leading-6 text-gray-500" id={"#{@id}-input-hint"}><%= @hint %></span>
     </div>
     <div class={"input-wrapper #{@type}"}>

      <span
       :for={x <- @add_on}
       class={["add-on", x[:inline] &&  "inline"]}
       ><%= render_slot(x, @id) %></span>

       <textarea
         type={@type}
         name={@name}
         id={@id}
         rows={@rows || 4}
         value={Phoenix.HTML.Form.normalize_value(@type, @value)}
         class={[
            "textarea-input",
            @add_on != [] && "add-on",
            @right_add_on != [] && "right-add-on",
            @errors != [] && "clean" || "error",
         ]}
         aria-describedby={@description && "#{@id}-input-description"}
         {@rest}
       ><%= @value %></textarea>

      <span
       :for={x <- @right_add_on}
       class={["right-add-on", x[:inline] &&  "inline"]}
      ><%= render_slot(x, @id) %></span>

       <span :if={@errors != []} class="right-add-on inline">
         <svg class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
           <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
         </svg>
       </span>

     </div>
     <p :if={@description && @description != ""}
         class="mt-2 text-sm text-gray-500"
         class={[
           "input-description",
           @errors == [] && "clean" || "error"
         ]}
         id={"#{@id}-input-description"}><%= @description %></p>
    </div>
    """
  end



  def tailwind_input(%{type: "select"} = assigns) do
    ~H"""
    <div id={@id} phx-feedback-for={@name} class="tailwind-input"  aria-expanded="false">
     <div class="flex justify-between">
       <label :if={@label && @label != ""} for="{@id}" class="block text-sm font-medium leading-6 text-gray-900"><%= @label %></label>
       <label :if={@hidden_label && @hidden_label != ""} for="{@id}" class="sr-only"><%= @hidden_label %></label>
       <span :if={@hint && @hint != ""} class="text-sm leading-6 text-gray-500" id={"#{@id}-input-hint"}><%= @hint %></span>
     </div>


       <input
              id={"#{@id}-selected-#{@value}"}
              type="checkbox"
              checked
              class="hidden"
              value={@value} name={@name} />
       <div class={" relative mt-2"}>
        <button
    phx-click={JS.set_attribute({"aria-expanded", "true"}, to: "##{@id}")}
    type="button" class={"relative w-full"} aria-haspopup="listbox" aria-labelledby="listbox-label">
<div class={"input-wrapper #{@type}"}>
        <span
        :for={x <- @add_on}
        class={["add-on", x[:inline] &&  "inline"]}
        ><%= render_slot(x, @id) %></span>

      <%= if @value do %>
          <%= if @display_option == [] do %>
              <span class="text-input pl-2 flex items-center"><%= @value %></span>
          <% else %>
              <span class="text-input pl-2 flex items-center"><%= render_slot(@display_option, option: @value) %></span>
          <% end %>
      <% else %>
          <span class="text-input pl-2 flex items-center"><%= @label || @hidden_label || "Select" %></span>
      <% end %>

          <span class="pointer-events-none absolute m-0 p-0 inset-y-0 right-0 ml-3 flex items-center pr-2">
            <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z" clip-rule="evenodd" />
            </svg>
          </span>
</div>
        </button>

      <ul class="select-dropdown"
          phx-click-away={JS.set_attribute({"aria-expanded", "false"}, to: "##{@id}")}
          tabindex="-1"
          role="listbox"
          aria-labelledby="listbox-label"
        >



      <li :for={option <- @options}
        id={"#{@id}-select-li-#{option[:value]}"}
        class="text-gray-900 relative cursor-default select-none py-2 pl-3 pr-9"
        role="option"
        >
        <%= if @multiple do %>
          <input id={"#{@id}-select-#{option[:value]}"} class="hidden" type="checkbox" value={option[:value]} name={"#{@name}[]"} />
          <label for={"#{@id}-select-#{option[:value]}"}>
            <div class="flex items-center">
              <%= if @display_option == [] do %>
                  <span class="ml-3 block truncate"><%= option[:key] %></span>
              <% else %>
                  <span class="ml-3 block truncate"><%= option[:key] %></span>
              <% end %>
            </div>
          </label>
        <% else %>
          <input
              id={"#{@id}-select-#{option.value}"}
              type="checkbox"
              class="hidden"
              value={option[:value]} name={@name} />
          <label
            phx-click={JS.set_attribute({"aria-expanded", "false"}, to: "##{@id}")}
            for={"#{@id}-select-#{option[:value]}"}>
            <div class="flex items-center">
              <%= if @display_option == [] do %>
                  <span class="ml-3 block truncate"><%= option[:key] %></span>
              <% else %>
                  <span class="ml-3 block truncate"><%= option[:key] %></span>
              <% end %>
            </div>
          </label>
        <% end %>


      </li>


    </ul>

      </div>




     <p :if={@description && @description != ""}
         class="mt-2 text-sm text-gray-500"
         class={[
           "input-description",
           @errors == [] && "clean" || "error"
         ]}
         id={"#{@id}-input-description"}><%= @description %></p>
    </div>
    """
  end


  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def tailwind_input(%{type: "combo-select"} = assigns) do
    ~H"""
    <div id={@id} phx-feedback-for={@name} class="tailwind-input">
      <div class="flex justify-between">
        <label :if={@label && @label != ""} for="{@id}" class="block text-sm font-medium leading-6 text-gray-900"><%= @label %></label>
        <label :if={@hidden_label && @hidden_label != ""} for="{@id}" class="sr-only"><%= @hidden_label %></label>
        <span :if={@hint && @hint != ""} class="text-sm leading-6 text-gray-500" id={"#{@id}-input-hint"}><%= @hint %></span>
      </div>
      <div class={"input-wrapper #{@type}"}>

      <div :if={is_map(@options)} >

          <div class="border-b border-gray-200">
            <nav class="-mb-px flex" aria-label="Tabs">
              <!-- Current: "border-indigo-500 text-indigo-600", Default: "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700" -->
              <a :for={{section, _} <- @options}
                  href="#"
                  class={"tab tab-#{ "#{section}" |> String.replace(" ", "_")}"}
                  phx-click={
                    JS.set_attribute({"aria-current", ""}, to: "##{@id} nav a")
                    |> JS.set_attribute({"aria-current", ""}, to: "##{@id} .page")
                    |> JS.set_attribute({"aria-current", "page"}, to: "##{@id} nav a.tab-#{ "#{section}" |> String.replace(" ", "_")}")
                    |> JS.set_attribute({"aria-current", "page"}, to: "##{@id} .page.tab-#{ "#{section}" |> String.replace(" ", "_")}")
                 }
              ><%= section %></a>
            </nav>
            <div :for={{section, items} <- @options}
                   class={"page tab-#{ "#{section}" |> String.replace(" ", "_")}"}
              >
      <div :for={item <- items} class="">
        <%= if @option != [] do %>
          <%= render_slot(@option, %{id: @id, name: @name, item: @item}) %>
        <% else %>
          <div class="relative flex items-start">
            <div class="flex h-6 items-center">
              <input id={"#{@id}-#{item[:value]}"}
                     name={"#{@name}[]"}
                     type="checkbox"
                     value={item[:value]}
                     {Enum.find_value(@value || [],
                        fn
                          (%{id: id}) -> item[:value] == id && [{"checked","true"}]
                          (%{data: %{id: id}}) -> item[:value] == id && [{"checked","true"}]
                          _ -> nil
                        end) || []
                     }
                     class="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-600 ">
            </div>
            <div class="ml-3 text-sm leading-6">
              <label for={"#{@id}-#{item[:value]}"} class="font-medium text-gray-900"><%= item[:key].name %></label>
              <p id={"#{@id}-#{item[:value]}-description"} class="text-gray-500"><%= item[:key].description %>.</p>
            </div>
          </div>

        <% end %>

      </div>



            </div>
          </div>

      </div>
      </div>
    </div>
    """
  end

  def tailwind_input(%{type: "search"} = assigns) do
    ~H"""


    <div id={@id} phx-feedback-for={@name} class="tailwind-input"
    aria-hidden="true"
    aria-expanded="false"

    >
     <div class="flex justify-between">
       <label :if={@label && @label != ""} for="{@id}" class="block text-sm font-medium leading-6 text-gray-900"><%= @label %></label>
       <label :if={@hidden_label && @hidden_label != ""} for="{@id}" class="sr-only"><%= @hidden_label %></label>
       <span :if={@hint && @hint != ""} class="text-sm leading-6 text-gray-500" id={"#{@id}-input-hint"}><%= @hint %></span>
     </div>
     <div class={"input-wrapper #{@type}"}>

       <div class="relative mt-2">
        <button

    type="button"
    phx-click={
               JS.set_attribute({"aria-hidden", "false"}, to: "##{@id}")
              }
    class="relative w-full cursor-default rounded-md bg-white py-1.5 pl-3 pr-10 text-left text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 sm:text-sm sm:leading-6" aria-haspopup="listbox" aria-expanded="true" aria-labelledby="listbox-label">


    <%= if @multiple do %>

     <ul :if={@multiple}
              class="search-selected"
              role="listbox">


            <li :if={@value == [] || @value == nil}>Multi Select</li>

            <li
            :for={item <- @value || []}
            id={"selected-#{@id}-#{if Map.has_key?(item, :data), do: item.data.id, else: get_in(item, [Access.key(:id)]) || get_in(item, [Access.key("id")]) }-selected"}
            class="relative cursor-default select-none py-2 pl-3 pr-9 text-gray-900" role="option" tabindex="-1">
            <%
                entry = case item do
                    entry = %{id: id} -> entry
                    entry = %{"id" => id} -> %{id: entry["id"], category: entry["category"], name: entry["name"]}
                    entry = %{data: %{id: id}} -> entry.data
                end
            %>
            <input id={"#{@id}-selected-#{entry.id}"} class="checkbox inline-block" type="checkbox" checked value={entry.id} name={"#{@name}[]"} />


            <label class="inline-block" for={"#{@id}-selected-#{entry.id}"}>
              <%= if @display_option == [] do %>
                  <span class="ml-3 block truncate"><%= entry %></span>
              <% else %>
                  <%= render_slot(@display_option, %{id: "#{@id}", option: entry, name: "edit-#{@name}[selected]", value: @value}) %>
              <% end %>
            </label>
          </li>

    </ul>

    <% else %>
      <%= case @value do %>
      <% %Ecto.Association.NotLoaded{} -> %>
      <span class="search-current flex items-center">
          <span class="ml-3 block truncate"><%= @label || @hidden_label || "Search" %></span>
      </span>
      <% nil -> %>
      <span class="search-current flex items-center">
          <span class="ml-3 block truncate"><%= @label || @hidden_label || "Search" %></span>
      </span>
      <% %Ecto.Changeset{data: data}  -> %>
        <input class="hidden" id={"#{@id}-selected"} type="checkbox" name={@name} checked value={data.id}/>
        <span class="flex items-center">
          <%= if @display_option == [] do %>
              <span class="ml-3 block truncate"><%= @value %></span>
          <% else %>
              <%= render_slot(@display_option, %{id: @id, option: data}) %>
          <% end %>
        </span>
      <% _  -> %>
        <input class="hidden" id={"#{@id}-selected"} type="checkbox" name={@name} checked value={@value.id}/>
        <span class="flex items-center">
          <%= if @display_option == [] do %>
              <span class="ml-3 block truncate"><%= @value %></span>
          <% else %>
              <%= render_slot(@display_option, %{id: @id, option: @value}) %>
          <% end %>
        </span>
      <% end %>
      <% end %>

      <input phx-change="search"
           phx-click={JS.set_attribute({"aria-expanded", "true"}, to: "##{@id}")}
           id={"select-#{@id}"}
           name={"select-#{@name}"}
           type="text"
           class="search-filter" role="combobox"
           aria-controls="options"
           aria-expanded="true"
           value={@search || ""}
           placeholder={@label || @hidden_label || "Search #{@id}"}
    />



          <span class="pointer-events-none absolute inset-y-0 right-0 ml-3 flex items-center pr-2">
            <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z" clip-rule="evenodd" />
            </svg>
          </span>
        </button>



      <ul class="search-dropdown"
          phx-click-away={
JS.set_attribute({"aria-expanded", "false"}, to: "##{@id}")
      |> JS.set_attribute({"aria-hidden", "true"}, to: "##{@id}")
    }
          tabindex="-1"
          role="listbox"
          aria-labelledby="listbox-label"
        >


      <%= if is_map(@options) do %>

      <li :for={{category, options} <- @options} >
      <%= category %>
      <ul>
       <li :if={length(options) == 0}>
      No Matches
      </li>
      <li :for={option <- options}
        id={"#{@id}-select-li-#{option[:value]}"}
        class="text-gray-900 relative cursor-default select-none py-2 pl-3 pr-9"
        role="option"
        >
        <%= if @multiple do %>

          <%
          existing =  Enum.find_value(@value || [],
                  fn
                    (%{id: id}) -> id == option.value
                    (%{data: %{id: id}}) -> id == option.value
                    (_) -> nil
                  end
                )
          %>

          <%= if existing do %>
          <input
            id={"#{@id}-select-#{option[:value]}"}
            class="checkbox inline-block"
            type="checkbox"
            value={"has-" <> option[:value]}
            name={"#{@name}[]"}
            checked
          />
          <% else %>
      <input
            id={"#{@id}-select-#{option[:value]}"}
            class="checkbox inline-block"
            type="checkbox"
            value={"add-" <> option[:value]}
            name={"#{@name}[]"}

          />
          <% end %>
          <label class="inline-block" for={"#{@id}-select-#{option[:value]}"}>
            <div class="flex items-center">
              <%= if @display_option == [] do %>
                  <span class="ml-3 block truncate"><%= option[:key] %></span>
              <% else %>
                  <%= render_slot(@display_option, %{id: @id, option: option.key, name: @name, value: @value}) %>
              <% end %>
            </div>
          </label>
        <% else %>
          <input id={"#{@id}-select-#{option[:value]}"} class="hidden" type="checkbox" value={option[:value]} name={"edit-#{@name}"} />
          <label phx-click={
      JS.set_attribute({"aria-hidden", "true"}, to: "##{@id}")
      |> JS.set_attribute({"aria-expanded", "false"}, to: "##{@id}")

    } for={"#{@id}-select-#{option[:value]}"}>
            <div class="flex items-center">
              <%= if @display_option == [] do %>
                  <span class="ml-3 block truncate"><%= option.key %></span>
              <% else %>
                  <%= render_slot(@display_option, %{id: @id, option: option.key, name: @name, value: @value}) %>
              <% end %>
            </div>
          </label>
        <% end %>


      </li>

      </ul>
      </li>




      <% else %>
       <li :if={length(@options) == 0}>
      No Matches
      </li>
      <li :for={option <- @options}
        id={"#{@id}-select-li-#{option[:value]}"}
        class="text-gray-900 relative cursor-default select-none py-2 pl-3 pr-9"
        role="option"
        >
        <%= if @multiple do %>
          <input class="checkbox inline-block" id={"#{@id}-select-#{option[:value]}"} class="hidden" type="checkbox" value={option[:value]} name={"select-#{@name}[select][]"} />
          <label class="inline-block" for={"#{@id}-select-#{option[:value]}"}>
            <div class="flex items-center">
              <%= if @display_option == [] do %>
                  <span class="ml-3 block truncate"><%= option[:key] %></span>
              <% else %>
                  <span class="ml-3 block truncate"><%= option[:key] %></span>
              <% end %>
            </div>
          </label>
        <% else %>
          <input id={"#{@id}-select-#{option[:value]}"} class="hidden" type="checkbox" value={option[:value]} name={"edit-#{@name}"} />
          <label phx-click={
      JS.set_attribute({"aria-hidden", "true"}, to: "##{@id}")
      |> JS.set_attribute({"aria-expanded", "false"}, to: "##{@id}")

    } for={"#{@id}-select-#{option[:value]}"}>
            <div class="flex items-center">
              <%= if @display_option == [] do %>
                  <span class="ml-3 block truncate"><%= option.key %></span>
              <% else %>
                  <%= render_slot(@display_option, %{id: @id, option: option.key, name: @name, value: @value}) %>
              <% end %>
            </div>
          </label>
        <% end %>


      </li>
      <% end %>




    </ul>

      </div>



     </div>
     <p :if={@description && @description != ""}
         class="mt-2 text-sm text-gray-500"
         class={[
           "input-description",
           @errors == [] && "clean" || "error"
         ]}
         id={"#{@id}-input-description"}><%= @description %></p>
    </div>


    """
  end


end
