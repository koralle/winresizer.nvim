# winresizer.nvim

A Neovim plugin for easy window resizing, moving, and focusing, written in pure Lua.  
This is a Lua port of the original [winresizer](https://github.com/simeji/winresizer) Vim plugin.

## Features

- **Resize windows**: Easily resize split windows using hjkl keys
- **Move windows**: Swap window positions  
- **Focus windows**: Navigate between windows
- **Customizable**: Configure key mappings and behavior
- **Pure Lua**: Built specifically for Neovim with Lua

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'koralle/winresizer.nvim',
  config = function()
    require('winresizer').setup()
  end
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'koralle/winresizer.nvim',
  config = function()
    require('winresizer').setup()
  end
}
```

## Usage

### Default Key Mapping

- Press `<C-E>` to start resize mode
- Use `h`, `j`, `k`, `l` to resize windows
- Press `Enter` to finish or `q` to cancel

### Commands

- `:WinResizerStartResize` - Start resize mode
- `:WinResizerStartMove` - Start move mode  
- `:WinResizerStartFocus` - Start focus mode

## Configuration

```lua
require('winresizer').setup({
  start_key = '<C-E>',        -- Key to start winresizer
  start_mode = 'resize',      -- Default mode: 'resize', 'move', or 'focus'
  resize_count = 3,           -- Amount to resize by
  keycode_left = 104,         -- Key code for 'h'
  keycode_down = 106,         -- Key code for 'j'  
  keycode_up = 107,           -- Key code for 'k'
  keycode_right = 108,        -- Key code for 'l'
  keycode_finish = 13,        -- Key code for Enter
  keycode_cancel = 113,       -- Key code for 'q'
})
```

## Modes

### Resize Mode (default)
Resize the current window by expanding or shrinking its dimensions.

### Move Mode  
Move windows to different positions within the current tab.

### Focus Mode
Navigate between windows without resizing or moving them.

## License

MIT License - see the original [winresizer](https://github.com/simeji/winresizer) plugin for reference.
