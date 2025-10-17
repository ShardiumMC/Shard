require "json"
require "./minimessage"

module MOTDHandler
  # MOTD configuration structure
  struct MOTDConfig
    property version_name : String
    property protocol : Int32
    property max_players : Int32
    property online_players : Int32
    property motd_text : String
    property use_minimessage : Bool

    def initialize(
      @version_name = "Shard 0.1.0",
      @protocol = 772,
      @max_players = 20,
      @online_players = 0,
      @motd_text = "<gray>A Minecraft Server",
      @use_minimessage = true
    )
    end
  end

  # Default MOTD configuration
  @@config = MOTDConfig.new(
    version_name: "Shard 0.1.0",
    protocol: 772,
    max_players: 20,
    online_players: 0,
    motd_text: "<gray>Running a <gradient:#00B7FF:#0043FF><bold>Shard</bold></gradient> <gray>Server on <color:#00B7FF><bold>1.21.8</bold></color></gray>",
    use_minimessage: true
  )

  # Set the MOTD configuration
  def self.configure(config : MOTDConfig)
    @@config = config
  end

  # Set MOTD text
  def self.set_motd(text : String, use_minimessage : Bool = true)
    @@config.motd_text = text
    @@config.use_minimessage = use_minimessage
  end

  # Set player count
  def self.set_players(online : Int32, max : Int32)
    @@config.online_players = online
    @@config.max_players = max
  end

  # Get the formatted MOTD text
  def self.get_formatted_motd : String
    if @@config.use_minimessage
      MiniMessage.parse(@@config.motd_text)
    else
      @@config.motd_text
    end
  end

  # Generate the status response JSON
  def self.generate_status_json : String
    {
      "version" => {
        "name" => @@config.version_name,
        "protocol" => @@config.protocol
      },
      "players" => {
        "max" => @@config.max_players,
        "online" => @@config.online_players
      },
      "description" => parse_to_json_component(get_formatted_motd)
    }.to_json
  end

  # Convert legacy § formatted text to JSON chat components
  private def self.parse_to_json_component(text : String)
    components = [] of Hash(String, String | Bool)
    current_text = ""
    current_color = ""
    current_bold = false
    current_italic = false
    current_underlined = false
    current_strikethrough = false
    current_obfuscated = false

    i = 0
    while i < text.size
      if text[i] == '§' && i + 1 < text.size
        # Save current component if we have text
        if !current_text.empty?
          component = {} of String => (String | Bool)
          component["text"] = current_text
          component["color"] = current_color if !current_color.empty?
          component["bold"] = true if current_bold
          component["italic"] = true if current_italic
          component["underlined"] = true if current_underlined
          component["strikethrough"] = true if current_strikethrough
          component["obfuscated"] = true if current_obfuscated
          components << component
          current_text = ""
        end

        # Parse format code
        code = text[i + 1]
        case code
        when 'x' # RGB color - next 6 characters are hex digits with § separators
          if i + 13 < text.size
            hex = ""
            hex += text[i + 3].to_s  # R1
            hex += text[i + 5].to_s  # R2
            hex += text[i + 7].to_s  # G1
            hex += text[i + 9].to_s  # G2
            hex += text[i + 11].to_s # B1
            hex += text[i + 13].to_s # B2
            current_color = "##{hex}"
            i += 14
            next
          end
        when '0' then current_color = "black"
        when '1' then current_color = "dark_blue"
        when '2' then current_color = "dark_green"
        when '3' then current_color = "dark_aqua"
        when '4' then current_color = "dark_red"
        when '5' then current_color = "dark_purple"
        when '6' then current_color = "gold"
        when '7' then current_color = "gray"
        when '8' then current_color = "dark_gray"
        when '9' then current_color = "blue"
        when 'a' then current_color = "green"
        when 'b' then current_color = "aqua"
        when 'c' then current_color = "red"
        when 'd' then current_color = "light_purple"
        when 'e' then current_color = "yellow"
        when 'f' then current_color = "white"
        when 'l' then current_bold = true
        when 'o' then current_italic = true
        when 'n' then current_underlined = true
        when 'm' then current_strikethrough = true
        when 'k' then current_obfuscated = true
        when 'r' # Reset
          current_color = ""
          current_bold = false
          current_italic = false
          current_underlined = false
          current_strikethrough = false
          current_obfuscated = false
        end
        i += 2
      else
        current_text += text[i]
        i += 1
      end
    end

    # Add final component
    if !current_text.empty?
      component = {} of String => (String | Bool)
      component["text"] = current_text
      component["color"] = current_color if !current_color.empty?
      component["bold"] = true if current_bold
      component["italic"] = true if current_italic
      component["underlined"] = true if current_underlined
      component["strikethrough"] = true if current_strikethrough
      component["obfuscated"] = true if current_obfuscated
      components << component
    end

    # Return in the correct format
    if components.size == 1
      components[0]
    else
      {"text" => "", "extra" => components}
    end
  end

  # Quick method to create a gradient text
  def self.gradient(text : String, *colors : String) : String
    color_list = colors.join(":")
    "<gradient:#{color_list}>#{text}</gradient>"
  end

  # Quick method to create colored text
  def self.color(text : String, hex : String) : String
    "<color:#{hex}>#{text}</color>"
  end
end
