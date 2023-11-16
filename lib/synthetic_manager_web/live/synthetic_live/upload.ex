defmodule SyntheticManagerWeb.SyntheticLive.Upload do
  use SyntheticManagerWeb, :live_view
  alias SyntheticManager.Synthetics.Synthetic
  alias SyntheticManager.Synthetics.Synthetic.Message
  @impl true
  def mount(_params, _session, socket) do
    raw =
      """
      - name: "Elixir Code Helper"
        group: Prefixes-CodeGeneration
        facets:
          - Code Generation
        notes: "This LLM assists with generating Elixir code for different functionalities as requested by the user."
        messages:
          - role: system
            content: |
              ⌜🖥️➤
              @with NPL@0.5
              # MASTER PROMPT
              You are a pair programmer assistant with expertise in Elixir. Your main role is to assist users by generating Elixir code based on the functionality descriptions they provide.
              ⌟
            note: "Sets up the LLM as an Elixir pair programming assistant."
          - role: user
            content: "Can you create a function to check if a number is prime?"
            note: "First user request for a prime-checking function."
          - role: assistant
            content: |
              ```elixir
              defmodule MathUtils do
                def is_prime(number) when number <= 1 do
                  false
                end
                def is_prime(number) do
                  Enum.none?(2..div(number, 2), fn x -> rem(number, x) == 0 end)
                end
              end
              ```
            note: "Assistant outputs an Elixir function for checking prime numbers."
          - role: user
            content: "I need a function that reverses each string in a list."
            note: "Second user request for string reversal."
          - role: assistant
            content: |
              ```elixir
              defmodule StringUtils do
                def reverse_strings(string_list) do
                  Enum.map(string_list, &String.reverse/1)
                end
              end
              ```
            note: "Assistant provides an Elixir function to reverse strings."
          - role: user
            content: "Write a function that returns the factorial of a number"
            note: "Third user request for a factorial function."
          - role: assistant
            content: |
              ```elixir
              defmodule MathUtils do
                def factorial(0), do: 1
                def factorial(n) when n > 0 do
                  n * factorial(n - 1)
                end
              end
              ```
            note: "Assistant generates an Elixir function to calculate factorial."
          - role: user
            content: "Please generate an Elixir function that merges two lists and removes duplicates."
            note: "Fourth user request for a list merge function."
          - role: assistant
            content: |
              ```elixir
              defmodule ListUtils do
                def merge_unique(list1, list2) do
                  list1 ++ list2 |> Enum.uniq()
                end
              end
              ```
            note: "Assistant writes an Elixir function to merge lists and remove duplicates."
          - role: user
            content: "How would I write a function to fetch and return the current system time formatted as YYYY-MM-DD HH:MM:SS?"
            note: "Fifth user request for a time fetching function."
          - role: assistant
            content: |
              ```elixir
              defmodule TimeUtils do
                def current_system_time do
                  DateTime.now!("Etc/UTC") |> DateTime.truncate(:second) |> DateTime.to_string()
                end
              end
              ```
      """
    socket = assign(socket, :raw, raw)

    {:ok, socket}
  end
  @keith 1
  @noizu_labs 1
  @roles %{
    "user" => :user,
    "assistant" => :assistant,
    "system" => :system,
    "function" => :function,
    "function_call" => :function_call,
    "function_response" => :function_response
  }


  defp extract_time(nil), do: nil
  defp extract_time(%DateTime{} = x), do: x
  defp extract_time(s) when is_bitstring("s") do
    case DateTime.from_iso8601(s) do
      {:ok, t} -> t
      _ -> nil
    end
  end
  defp role(role), do: @roles[role]
  defp synthetic_id("ref.synthetic." <> id), do: id
  defp synthetic_id(_), do: nil
  defp org_id("ref.organization." <> id), do: id
  defp org_id(_), do: nil
  defp user_id("ref.user." <> id), do: id
  defp user_id(_), do: nil
  defp message_id("ref.message." <> id), do: id
  defp message_id(_), do: nil
  defp feature_id("ref.feature." <> id), do: id
  defp feature_id(_), do: nil

  @impl true
  def handle_event("synthetics:upload", form, socket) do
    case YamlElixir.read_all_from_string(form["upload"]) do
      {:ok, [json]} when is_list(json) ->
        entries = json |> Enum.map(
                            fn
                              x = %{"messages" => messages} ->

                                features = (x["features"] || [])
                                           |> Enum.map(&feature_id/1)
                                           |> Enum.reject(&is_nil/1)
                                messages = Enum.with_index(messages,
                                  fn
                                    m = %{"role" => role, "content"  => content}, sequence ->
                                    role = role(role)
                                    note = m["note"] || ""
                                    id = message_id(m["id"])
                                    features = (x["features"] || [])
                                               |> Enum.map(&feature_id/1)
                                               |> Enum.reject(&is_nil/1)
                                    inserted_at = extract_time(x["inserted_at"])
                                    updated_at = extract_time(x["updated_at"])

                                    %Message{
                                      id: id,
                                      features: features,
                                      content: content,
                                      sequence: sequence,
                                      role: role,
                                      note: note,
                                      inserted_at: inserted_at,
                                      updated_at: updated_at,
                                    }
                                    _,_ -> nil
                                  end
                                ) |> Enum.reject(&is_nil/1)
                                %Synthetic{
                                  id: synthetic_id(x["id"]),
                                  name: x["name"],
                                  description: x["description"] || x["notes"],
                                  hidden_prompt: x["hidden_prompt"],
                                  organization_id: org_id(x["organization_id"]),
                                  user_id: user_id(x["user_id"]),
                                  features: features,
                                  messages: messages,
                                  inserted_at: extract_time(x["inserted_at"]),
                                  updated_at: extract_time(x["updated_at"]),
                                }
                              _ -> nil
                            end
                          )
                  |> Enum.reject(&is_nil/1)
         {
           :noreply,
           socket |> assign(:json, entries)
         }
      _ ->
        # Error
        {:noreply, socket}
    end
  end

end
