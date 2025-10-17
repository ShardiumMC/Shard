# Shard

A lightweight, fast Minecraft server implementation written in Crystal with MiniMessage support for beautiful MOTDs.

## Features

- ✨ **MiniMessage Support** - Full support for MiniMessage format with gradients, colors, and decorations
- 🎨 **Hex Color Support** - Use any hex color in your MOTD
- ⚡ **Fast & Lightweight** - Built with Crystal for optimal performance
- 🔌 **Server List Ping** - Full status response and ping/pong implementation
- 📊 **Latency Display** - Shows connection latency in milliseconds

## Installation

1. Make sure you have Crystal installed
2. Clone this repository
3. Build the project:
   ```bash
   crystal build src/shard.cr -o shard.exe
   ```

## Usage

### Basic Usage

Run the server:

```bash
./shard.exe
```

The server will start on `0.0.0.0:25565` by default.

### Customizing MOTD

The MOTD uses MiniMessage format. You can customize it in `src/motd_handler.cr`:

```crystal
# Simple gradient
MOTDHandler.set_motd("<gradient:#00B7FF:#0043FF>Shard Server</gradient>")

# Multiple colors and decorations
MOTDHandler.set_motd("<gray>Running a <gradient:#00B7FF:#0043FF><bold>Shard</bold></gradient> Server")

# Rainbow gradient
MOTDHandler.set_motd("<gradient:#ff0000:#ff7f00:#ffff00:#00ff00:#0000ff:#4b0082:#9400d3>Rainbow!</gradient>")
```

### MiniMessage Format Reference

**Colors:**

- Named: `<red>`, `<blue>`, `<green>`, `<yellow>`, `<gold>`, etc.
- Hex: `<color:#RRGGBB>text</color>` or `<#RRGGBB>text</#RRGGBB>`
- Gradient: `<gradient:#color1:#color2>text</gradient>`

**Decorations:**

- `<bold>` or `<b>` - Bold text
- `<italic>` or `<i>` - Italic text
- `<underlined>` or `<u>` - Underlined text
- `<strikethrough>` or `<st>` - Strikethrough text
- `<obfuscated>` or `<obf>` - Obfuscated text

**Special:**

- `<reset>` - Reset all formatting

See [motd_examples.md](motd_examples.md) for more examples.

For full MiniMessage documentation: https://docs.papermc.io/adventure/minimessage/format/

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/ShardiumMC/Shard/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [ezTxmMC](https://github.com/ezTxmMC) - creator and maintainer
- [SyntaxJason](https://github.com/SyntaxJason) - creator and maintainer
