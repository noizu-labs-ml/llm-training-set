alias SyntheticManager.Features

unless SyntheticManager.Repo.get(SyntheticManager.SeedTags.Tag, "initial-features")  do
  now = DateTime.utc_now()
  template = %{name: nil, category: :basic_syntax, description: nil, inserted_at: now, updated_at: now}

  # Basic Syntax Features
  %{template | name: "basic_syntax__attention", description: "Marks important instructions or points of emphasis."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__definition", description: "Used for defining entities and NLP extensions."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__highlight", description: "Highlights important terms, phrases, examples."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__positive", description: "Indicates a positive or correct example."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__negative", description: "Marks a negative or incorrect example."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__placeholder", description: "Placeholder for content to be filled in."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__backticks", description: "Encloses text for emphasis or technical reference."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__etcetera", description: "Indicates additional cases to be inferred."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__qualifier", description: "Used to qualify prompts or instructions."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__ellipsis", description: "Placeholder for omitted or extra content."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__literal_output", description: "Specifies text to be output without processing."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__section_separator", description: "Separates sections in prompts or documents."}
  |> Features.create_feature()

  %{template | name: "basic_syntax__symbolic_math_logic", description: "Use math/logic symbols for behavior/rules."}
  |> Features.create_feature()

  now = DateTime.utc_now()
  template = %{name: nil, category: :code_block, description: nil, inserted_at: now, updated_at: now}

  # Code Block Features
  %{template | name: "code_block__syntax", description: "Indicates a section defining syntax rules."}
  |> Features.create_feature()

  %{template | name: "code_block__format", description: "Specifies the format of information in code blocks."}
  |> Features.create_feature()

  %{template | name: "code_block__example", description: "Section for providing examples."}
  |> Features.create_feature()

  %{template | name: "code_block__notes", description: "Additional notes or annotations."}
  |> Features.create_feature()

  %{template | name: "code_block__state_machine", description: "Diagrams or descriptions of state machines."}
  |> Features.create_feature()

  %{template | name: "code_block__diagram", description: "Visual representations or schematics."}
  |> Features.create_feature()

  %{template | name: "code_block__template", description: "Preset formats or structures for content."}
  |> Features.create_feature()

  %{template | name: "code_block__behavior", description: "Describes expected or desired actions."}
  |> Features.create_feature()

  %{template | name: "code_block__context", description: "Provides background or situational information."}
  |> Features.create_feature()

  now = DateTime.utc_now()
  template = %{name: nil, category: :prompt_prefix, description: nil, inserted_at: now, updated_at: now}

  # Prompt Prefix Features
  %{template | name: "prompt_prefix__code_generation", description: "Indicates a prompt for code generation."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__feature_extraction", description: "Marks a prompt for extracting features or properties."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__summarization", description: "Denotes a prompt for summarizing content."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__sentiment_analysis", description: "Used for sentiment analysis prompts."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__text_classification", description: "Indicates classification of text or content."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__text_generation", description: "Marks prompts intended for text generation."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__named_entity_recognition", description: "For prompts involving entity recognition."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__machine_translation", description: "Used for language translation prompts."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__topic_modeling", description: "Denotes prompts related to topic modeling."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__question_answering", description: "Marks prompts for question-answering tasks."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__speech_recognition", description: "Indicates prompts for speech recognition tasks."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__text_to_speech", description: "Used for prompts involving text-to-speech conversion."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__image_captioning", description: "For prompts related to creating captions for images."}
  |> Features.create_feature()

  %{template | name: "prompt_prefix__conversation", description: "Indicates prompts aimed at conversational interaction."}
  |> Features.create_feature()


  now = DateTime.utc_now()
  template = %{name: nil, category: :directive, description: nil, inserted_at: now, updated_at: now}

  # Directive Features
  %{template | name: "directive__instruction", description: "Provides explicit instructions for tasks or responses."}
  |> Features.create_feature()

  %{template | name: "directive__reference_mark", description: "Marks sections for easy reference or documentation."}
  |> Features.create_feature()

  %{template | name: "directive__behavioral_notes", description: "Notes on behavior, purpose, or examples for clarity."}
  |> Features.create_feature()

  %{template | name: "directive__unique_id", description: "Generates a unique identifier for entities or elements."}
  |> Features.create_feature()

  %{template | name: "directive__interactivity", description: "Indicates instructions for enhancing user interactivity."}
  |> Features.create_feature()

  %{template | name: "directive__embedding", description: "Embeds content or instructions within output for integration."}
  |> Features.create_feature()

  %{template | name: "directive__timing", description: "Manages time-related aspects in prompts or responses."}
  |> Features.create_feature()

  %{template | name: "directive__table_generation", description: "Facilitates the structured display of data in tables."}
  |> Features.create_feature()

  now = DateTime.utc_now()
  template = %{name: nil, category: :agent, description: nil, inserted_at: now, updated_at: now}

  # Agent Features
  %{template | name: "agent__addressing", description: "Used to direct a comment or request to a specific agent."}
  |> Features.create_feature()

  %{template | name: "agent__definition", description: "Defines agent behavior or characteristics."}
  |> Features.create_feature()

  %{template | name: "agent__extension", description: "Extends an existing agent definition with additional features."}
  |> Features.create_feature()

  %{template | name: "agent__interaction", description: "Guides interactions with the agent."}
  |> Features.create_feature()

  %{template | name: "agent__reflection", description: "Encourages self-assessment and improvement in agents."}
  |> Features.create_feature()

  %{template | name: "agent__intention", description: "Clarifies the agent's purpose in a response."}
  |> Features.create_feature()

  %{template | name: "agent__mood", description: "Simulates the agent's mood in conversation."}
  |> Features.create_feature()

  %{template | name: "agent__memory", description: "Refers to the agent's recall of past interactions."}
  |> Features.create_feature()

  now = DateTime.utc_now()
  template = %{name: nil, category: :runtime_flag, description: nil, created_at: now, updated_at: now}

  # Runtime Flag Features
  %{template | name: "runtime_flag__global_flags", description: "Flags that apply globally across the system."}
  |> Features.create_feature()

  %{template | name: "runtime_flag__npl_level_flags", description: "Flags specific to NPL (Natural Language Processing Language) definitions."}
  |> Features.create_feature()

  %{template | name: "runtime_flag__agent_level_flags", description: "Flags that apply to specific agents for customized behavior."}
  |> Features.create_feature()

  %{template | name: "runtime_flag__response_level_flags", description: "Flags for single responses, temporarily overriding other settings."}
  |> Features.create_feature()

  %{template | name: "runtime_flag__precedence", description: "Determines the order of flag application in conflicting settings."}
  |> Features.create_feature()

  %{template | name: "runtime_flag__getter", description: "Retrieves the value of a flag, essential for dynamic flag management."}
  |> Features.create_feature()

  %{template | name: "runtime_flag__setter", description: "Sets or updates a flag value, allowing for modification of flag states."}
  |> Features.create_feature()

  %{template | name: "runtime_flag__mutate", description: "Alters the state of a flag conditionally, facilitating dynamic changes."}
  |> Features.create_feature()


  IO.puts "[initial-features] Executed"
  SyntheticManager.Repo.insert!(%SyntheticManager.SeedTags.Tag{name: "initial-features", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()})
else
  IO.puts "[initial-features] Already Applied"
end
