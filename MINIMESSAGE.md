# Shard Server - MiniMessage Implementation

## 📁 File Structure

```
src/
├── shard.cr          - Main server file
├── minimessage.cr    - MiniMessage parser implementation
└── motd_handler.cr   - MOTD configuration and management
```

## 🎨 Features Implemented

### 1. MiniMessage Parser (`minimessage.cr`)

- ✅ **Gradient Support**: `<gradient:#color1:#color2>text</gradient>`
- ✅ **Hex Colors**: `<color:#RRGGBB>text</color>` or `<#RRGGBB>text</#RRGGBB>`
- ✅ **Named Colors**: `<red>`, `<blue>`, `<green>`, etc.
- ✅ **Decorations**: `<bold>`, `<italic>`, `<underlined>`, `<strikethrough>`, `<obfuscated>`
- ✅ **Nested Tags**: Decorations work inside gradients
- ✅ **Color Interpolation**: Smooth gradient transitions
- ✅ **Reset**: `<reset>` to clear formatting

### 2. MOTD Handler (`motd_handler.cr`)

- ✅ **Configuration Management**: Easy MOTD customization
- ✅ **Player Count**: Set online/max players
- ✅ **MiniMessage Toggle**: Can use legacy § codes if needed
- ✅ **JSON Generation**: Automatic status response creation
- ✅ **Helper Methods**: `gradient()` and `color()` utilities

### 3. Main Server (`shard.cr`)

- ✅ **Integrated MOTD Handler**: Uses new system
- ✅ **Ping/Pong**: Full server list ping support
- ✅ **Latency Display**: Shows connection time in console
- ✅ **Clean Code**: Removed old hex_to_mc method (now in minimessage.cr)

## 📝 Usage Examples

### Basic Usage

```crystal
# Set a simple gradient MOTD
MOTDHandler.set_motd("<gradient:#00B7FF:#0043FF>Shard Server</gradient>")

# Set player count
MOTDHandler.set_players(5, 20)
```

### Complex MOTD

```crystal
# Gradient with decorations
MOTDHandler.set_motd(
  "<gray>Running a <gradient:#00B7FF:#0043FF><bold>Shard</bold></gradient> Server on <color:#00B7FF><bold>1.21.8</bold></color>"
)
```

### Rainbow Gradient

```crystal
MOTDHandler.set_motd(
  "<gradient:#ff0000:#ff7f00:#ffff00:#00ff00:#0000ff:#4b0082:#9400d3>Rainbow Text!</gradient>"
)
```

## 🔧 Technical Details

### Gradient Algorithm

1. Parse decoration tags first (bold, italic, etc.)
2. Extract hex colors from gradient tag
3. For each visible character:
   - Calculate progress through the text (0.0 to 1.0)
   - Determine which color segment to use
   - Interpolate between two colors
   - Apply hex color code while preserving decorations

### Color Interpolation

```crystal
# Linear interpolation between two RGB colors
r = r1 + (r2 - r1) * progress
g = g1 + (g2 - g1) * progress
b = b1 + (b2 - b1) * progress
```

### Minecraft Color Format

Hex colors are converted to Minecraft's format:

```
#00B7FF → §x§0§0§b§7§f§f
```

## 📚 Resources

- MiniMessage Documentation: https://docs.papermc.io/adventure/minimessage/format/
- Minecraft Color Codes: https://minecraft.fandom.com/wiki/Formatting_codes

## ✅ Testing

Run `crystal run test_minimessage.cr` to test all MiniMessage features.

## 🎯 Future Enhancements

- [ ] Click events
- [ ] Hover events
- [ ] Keybinds
- [ ] Translatable components
- [ ] Score components
- [ ] Selector components
