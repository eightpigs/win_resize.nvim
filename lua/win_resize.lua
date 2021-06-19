local config = {
  exclude_names = {
    ['NvimTree'] = true,
    [''] = true,
    ['fzf'] = true,
    ['packer'] = true
  },
  exclude_fts = { ['NvimTree'] = true, ['fzf'] = true, ['tagbar'] = true },
  resize_ratio = 1,
  target_width = 86,
  target_height = 26,
  min_win_count = 2
}

local default_win_width = -1
local default_win_height = -1

local function is_skip(bufnr)
  local name
  local ft
  if bufnr == -1 then
    name = vim.fn.bufname('%')
    ft = vim.bo.filetype
  else
    name = vim.fn.bufname(bufnr)
    ft = vim.fn.getbufvar(bufnr, '&filetype')
  end
  return config.exclude_names[name] ~= nil or config.exclude_fts[ft]
end

local function init_default()
  if default_win_width == -1 then
    default_win_width = vim.o.winwidth
  end
  if default_win_height == -1 then
    default_win_height = vim.o.winheight
  end
end

local function use_default()
  if vim.o.winwidth ~= default_win_width then
    vim.o.winwidth = default_win_width
  end
  if vim.o.winheight ~= default_win_height then
    vim.o.winheight = default_win_height
  end
end

local function check_win_count()
  local bufs = vim.fn.tabpagebuflist()
  local count = #bufs
  if count > config.min_win_count then
    for _, bufnr in pairs(bufs) do
      if is_skip(bufnr) then
        count = count - 1
      end
    end
  end
  return count > config.min_win_count
end

local function check_ratio_width()
  local cur_width = vim.fn.winwidth(vim.fn.winnr())
  local width_ratio = cur_width / config.target_width
  return width_ratio < config.resize_ratio
end

local function check_ratio_height()
  local cur_height = vim.fn.winheight(vim.fn.winnr())
  local height_ratio = cur_height / config.target_height
  return height_ratio < config.resize_ratio
end

local function resize()
  init_default()

  if is_skip(-1) then
    use_default()
    return
  end

  if check_win_count() then
    if check_ratio_width() then
      vim.o.winwidth = config.target_width
    end
    if check_ratio_height() then
      vim.o.winheight = config.target_height
    end
    vim.cmd [[wincmd =]]
  end
end

local function get_excludes(source, list)
  if list ~= nil and #list > 0 then
    source = {}
    for _, item in pairs(list) do
      source[item] = true
    end
  end
  return source
end

local function setup(cfg)
  cfg = cfg or {}

  config.exclude_fts = get_excludes(config.exclude_fts, cfg.exclude_fts)
  config.exclude_names = get_excludes(config.exclude_names, cfg.exclude_names)

  config.resize_ratio = cfg.resize_ratio or config.resize_ratio
  config.target_width = cfg.target_width or config.target_width
  config.target_height = cfg.target_height or config.target_height
  config.min_win_count = cfg.min_win_count or config.min_win_count
end

return { setup = setup, resize = resize }
