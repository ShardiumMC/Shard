module MiniMessage
  # Parse MiniMessage format and convert to Minecraft legacy format with § codes
  # Based on https://docs.papermc.io/adventure/minimessage/format/
  def self.parse(input : String) : String
    result = input.dup

    # Handle decorations first (they can be inside gradients)
    result = parse_decorations(result)

    # Handle gradient tags (must be after decorations)
    result = parse_gradient(result)

    # Handle color tags: <color:#hex>text</color> or <#hex>text</#hex>
    result = parse_color(result)

    # Handle named colors: <red>, <blue>, etc.
    result = parse_named_colors(result)

    # Handle reset: <reset>
    result = result.gsub(/<reset>/, "§r")

    result
  end

  private def self.parse_gradient(text : String) : String
    # Match <gradient:#hex1:#hex2:#hex3...>content</gradient>
    # This regex now allows § codes inside the gradient
    text.gsub(/<gradient:(#[0-9a-fA-F]{6}(?::#[0-9a-fA-F]{6})+)>([^<]+)<\/gradient>/) do |match|
      colors_str = $1
      content = $2

      # Extract hex colors
      colors = colors_str.split(':').select { |c| c.starts_with?("#") }

      if colors.size < 2
        content
      else
        # Apply gradient and add reset after
        apply_gradient(content, colors) + "§r"
      end
    end
  end

  private def self.apply_gradient(text : String, colors : Array(String)) : String
    return text if text.empty? || colors.size < 2

    result = ""
    # Extract only visible characters (not § codes)
    visible_chars = [] of Char
    i = 0
    while i < text.size
      if text[i] == '§' && i + 1 < text.size
        # Skip § and the next character (it's a format code)
        i += 2
      else
        visible_chars << text[i]
        i += 1
      end
    end

    char_count = visible_chars.size
    return text if char_count == 0

    visible_index = 0
    i = 0
    while i < text.size
      # If it's a format code, preserve it
      if text[i] == '§' && i + 1 < text.size
        result += text[i].to_s + text[i + 1].to_s
        i += 2
      else
        # Apply gradient color to this character
        progress = char_count > 1 ? visible_index.to_f / (char_count - 1).to_f : 0.0
        segment_size = 1.0 / (colors.size - 1)
        segment = (progress / segment_size).floor.to_i.clamp(0, colors.size - 2)

        segment_progress = (progress - (segment * segment_size)) / segment_size

        color1 = colors[segment]
        color2 = colors[segment + 1]

        interpolated = interpolate_color(color1, color2, segment_progress)
        result += "#{hex_to_mc(interpolated)}#{text[i]}"

        visible_index += 1
        i += 1
      end
    end

    result
  end

  private def self.interpolate_color(color1 : String, color2 : String, progress : Float64) : String
    c1 = parse_hex(color1)
    c2 = parse_hex(color2)

    r = (c1[:r] + (c2[:r] - c1[:r]) * progress).round.to_i
    g = (c1[:g] + (c2[:g] - c1[:g]) * progress).round.to_i
    b = (c1[:b] + (c2[:b] - c1[:b]) * progress).round.to_i

    "#%02x%02x%02x" % [r, g, b]
  end

  private def self.parse_hex(hex : String) : NamedTuple(r: Int32, g: Int32, b: Int32)
    hex = hex.lstrip('#')
    {
      r: hex[0..1].to_i(16),
      g: hex[2..3].to_i(16),
      b: hex[4..5].to_i(16)
    }
  end

  private def self.parse_color(text : String) : String
    # Handle <color:#hex>text</color>
    result = text.gsub(/<color:(#[0-9a-fA-F]{6})>([^<]+)<\/color>/) do |match|
      hex = $1
      content = $2
      "#{hex_to_mc(hex)}#{content}§r"
    end

    # Handle <#hex>text</#hex> shorthand
    result = result.gsub(/<(#[0-9a-fA-F]{6})>([^<]+)<\/\1>/) do |match|
      hex = $1
      content = $2
      "#{hex_to_mc(hex)}#{content}§r"
    end

    result
  end

  private def self.parse_named_colors(text : String) : String
    color_map = {
      "black" => "§0",
      "dark_blue" => "§1",
      "dark_green" => "§2",
      "dark_aqua" => "§3",
      "dark_red" => "§4",
      "dark_purple" => "§5",
      "gold" => "§6",
      "gray" => "§7",
      "dark_gray" => "§8",
      "blue" => "§9",
      "green" => "§a",
      "aqua" => "§b",
      "red" => "§c",
      "light_purple" => "§d",
      "yellow" => "§e",
      "white" => "§f"
    }

    result = text
    color_map.each do |name, code|
      result = result.gsub(/<#{name}>/, code)
      result = result.gsub(/<\/#{name}>/, "§r")
    end

    result
  end

  private def self.parse_decorations(text : String) : String
    decoration_map = {
      "bold" => "§l",
      "b" => "§l",
      "italic" => "§o",
      "i" => "§o",
      "underlined" => "§n",
      "u" => "§n",
      "strikethrough" => "§m",
      "st" => "§m",
      "obfuscated" => "§k",
      "obf" => "§k"
    }

    result = text
    decoration_map.each do |name, code|
      result = result.gsub(/<#{name}>/, code)
      result = result.gsub(/<\/#{name}>/, "§r")
    end

    result
  end

  # Convert hex color to Minecraft format (e.g., "#00B7FF" -> "§x§0§0§b§7§f§f")
  private def self.hex_to_mc(hex : String) : String
    hex = hex.lstrip('#')

    if hex.size != 6
      return ""
    end

    result = "§x"
    hex.downcase.each_char do |char|
      result += "§#{char}"
    end
    result
  end
end
