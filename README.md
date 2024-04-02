# nvimplugin-reloader
A simple plugin which provides user command to reload lua file. 
## Installation
### lazy
```lua
 {
    'jborkows/nvimplugin-reloader',
    config = function()
      local reloader = require 'reloader'
      reloader.setup(reloader.debug)
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

```

## Usage
In file execute `:PluginMode` to reload the file on saving.
