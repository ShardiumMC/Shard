require "./src/motd_handler"
require "./src/minimessage"

# Example 1: Testing MiniMessage parsing
puts "=== MiniMessage Parsing Examples ==="
puts

# Gradient with closing tag
gradient_text = "<gradient:#00B7FF:#0043FF>Gradient Text</gradient>"
puts "Input:  #{gradient_text}"
puts "Output: #{MiniMessage.parse(gradient_text)}"
puts

# Bold with closing tag
bold_text = "<bold>Bold text</bold> normal text"
puts "Input:  #{bold_text}"
puts "Output: #{MiniMessage.parse(bold_text)}"
puts

# Named colors with closing
color_text = "<red>Red</red> <blue>Blue</blue> <green>Green</green>"
puts "Input:  #{color_text}"
puts "Output: #{MiniMessage.parse(color_text)}"
puts

# Hex color with closing
hex_text = "<color:#FF0000>Red text</color> normal text"
puts "Input:  #{hex_text}"
puts "Output: #{MiniMessage.parse(hex_text)}"
puts

# Decorations
decoration_text = "<bold>Bold</bold> <italic>Italic</italic> <underlined>Underlined</underlined>"
puts "Input:  #{decoration_text}"
puts "Output: #{MiniMessage.parse(decoration_text)}"
puts

# Complex example with nested tags
complex_text = "<gray>Running a <gradient:#00B7FF:#0043FF><bold>Shard</bold></gradient> Server on <color:#00B7FF><bold>1.21.8</bold></color>"
puts "Input:  #{complex_text}"
puts "Output: #{MiniMessage.parse(complex_text)}"
puts

puts "=== MOTD Handler Examples ==="
puts

# Example 2: Using MOTD Handler
puts "Default MOTD:"
puts MOTDHandler.get_formatted_motd
puts

# Example 3: Changing MOTD
MOTDHandler.set_motd("<gradient:#ff0000:#ffff00:#00ff00>Rainbow Server!</gradient>")
puts "Custom MOTD:"
puts MOTDHandler.get_formatted_motd
puts

# Example 4: Setting player count
MOTDHandler.set_players(5, 20)
puts "Status JSON with 5/20 players:"
puts MOTDHandler.generate_status_json
puts

puts "=== All tests completed successfully! ==="
