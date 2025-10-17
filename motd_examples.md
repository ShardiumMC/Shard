# Shard Server MOTD Configuration Examples

# This file demonstrates how to use MiniMessage format in your MOTD

## Example 1: Simple gradient

# MOTDHandler.set_motd("<gradient:#00B7FF:#0043FF>Shard Server</gradient>")

## Example 2: Gradient with bold

# MOTDHandler.set_motd("<gradient:#00B7FF:#0043FF><bold>Shard Server</bold></gradient>")

## Example 3: Multiple colors and decorations

# MOTDHandler.set_motd("<gray>Running a <gradient:#00B7FF:#0043FF><bold>Shard</bold></gradient> Server on <color:#00B7FF><bold>1.21.8</bold></color>")

## Example 4: Using named colors

# MOTDHandler.set_motd("<red>Red text <blue>Blue text</blue> <green>Green text</green></red>")

## Example 5: Decorations

# MOTDHandler.set_motd("<bold>Bold</bold> <italic>Italic</italic> <underlined>Underlined</underlined>")

## Example 6: Complex rainbow gradient

# MOTDHandler.set_motd("<gradient:#ff0000:#ff7f00:#ffff00:#00ff00:#0000ff:#4b0082:#9400d3>Rainbow Text!</gradient>")

## MiniMessage Format Reference:

#

# Colors:

# - Named: <red>, <blue>, <green>, <yellow>, <aqua>, <gold>, <gray>, <white>, etc.

# - Hex: <color:#RRGGBB>text</color> or <#RRGGBB>text</#RRGGBB>

# - Gradient: <gradient:#color1:#color2:#color3>text</gradient>

#

# Decorations:

# - <bold> or <b> - Bold text

# - <italic> or <i> - Italic text

# - <underlined> or <u> - Underlined text

# - <strikethrough> or <st> - Strikethrough text

# - <obfuscated> or <obf> - Obfuscated/magic text

#

# Special:

# - <reset> - Reset all formatting

#

# See: https://docs.papermc.io/adventure/minimessage/format/

# Default MOTD (set in motd_handler.cr):

# "<gray>Running a <gradient:#00B7FF:#0043FF><bold>Shard</bold></gradient> Server on <color:#00B7FF><bold>1.21.8</bold></color>"
