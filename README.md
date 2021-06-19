#  win_resize.nvim

 Automatic resizing of Neovim windows.

 ![demo png](https://raw.githubusercontent.com/eightpigs/win_resize.nvim/screenshots/screenshots/demo.gif)

## Requirements

- Neovim

## Insallation

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'eightpigs/win_resize.nvim',
  config = function()
    require('win_resize').setup { min_win_count = 2, resize_ratio = 0.95 }
    vim.cmd [[
      augroup resizeWin
        autocmd!
        autocmd BufEnter * lua vide.view.resize()
      augroup END
    ]]
  end
}
```

## Configuration

```lua
{
  min_win_count = 2,
  target_width = 86,
  target_height = 26,
  resize_ratio = 0.95,
  exclude_fts = { 'NvimTree', 'fzf', '', 'packer' },
  exclude_names = { 'NvimTree', 'fzf', 'tagbar' }
}
```

- `min_win_count` (default: 2)

   Minimum number of open windows to enable the plugin.

   eg: `min_win_count = 3`, Resize when at least 3 windows are open.

- `target_width` (default: 86)

    Maximum width during resizing.

- `target_height` (default: 26)

    Maximum height during resizing.

- `resize_ratio` (default 0.95)

    The ratio of the current window size to the target size, and will be resized when the ratio is smaller.

    - width_ratio = `current_win_width / target_width`
    - height_ratio = `current_win_height / target_height`

    eg: `resize_ratio = 1`, Resize when ratio < 1 (current window width/height != target width/height)

- `exclude_fts` (default: {'NvimTree', '', 'fzf'})

    Filetypes that will not be resized.

- `exclude_names` (default: {'NvimTree', 'fzf', 'tagbar'})

    Buffer names that will not be resized.

### Usage

```lua
vim.cmd [[
  augroup resizeWin
    autocmd!
    autocmd BufEnter * lua require('win_resize').resize()
  augroup END
]]
```
