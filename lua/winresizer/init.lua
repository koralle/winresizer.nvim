local M = {}

local defaults = {
  gui_finish_key = '<CR>',
  gui_cancel_key = 'q',
  keycode_finish = 13,
  keycode_cancel = 113,
  keycode_left = 104,
  keycode_down = 106,
  keycode_up = 107,
  keycode_right = 108,
  resize_count = 3,
  start_key = '<C-E>',
  start_mode = 'resize',
}

local config = {}

local function get_char()
  local char = vim.fn.getchar()
  if type(char) == 'number' then
    return char
  end
  return vim.fn.char2nr(char)
end

local function win_resize_left()
  vim.cmd('vertical resize -' .. config.resize_count)
end

local function win_resize_down()
  vim.cmd('resize +' .. config.resize_count)
end

local function win_resize_up()
  vim.cmd('resize -' .. config.resize_count)
end

local function win_resize_right()
  vim.cmd('vertical resize +' .. config.resize_count)
end

local function win_move_left()
  vim.cmd('wincmd H')
end

local function win_move_down()
  vim.cmd('wincmd J')
end

local function win_move_up()
  vim.cmd('wincmd K')
end

local function win_move_right()
  vim.cmd('wincmd L')
end

local function win_focus_left()
  vim.cmd('wincmd h')
end

local function win_focus_down()
  vim.cmd('wincmd j')
end

local function win_focus_up()
  vim.cmd('wincmd k')
end

local function win_focus_right()
  vim.cmd('wincmd l')
end

local function get_resize_behavior()
  local winnr = vim.fn.winnr()
  local current_win_width = vim.fn.winwidth(winnr)
  local current_win_height = vim.fn.winheight(winnr)
  
  vim.cmd('wincmd l')
  local right_win_width = vim.fn.winwidth(vim.fn.winnr())
  
  vim.cmd('wincmd h')
  local left_win_width = vim.fn.winwidth(vim.fn.winnr())
  
  vim.cmd('wincmd j')
  local down_win_height = vim.fn.winheight(vim.fn.winnr())
  
  vim.cmd('wincmd k')
  local up_win_height = vim.fn.winheight(vim.fn.winnr())
  
  vim.fn.execute(winnr .. 'wincmd w')
  
  local behavior = {}
  
  if current_win_width == right_win_width then
    behavior.left = win_resize_right
    behavior.right = win_resize_left
  else
    behavior.left = win_resize_left
    behavior.right = win_resize_right
  end
  
  if current_win_height == down_win_height then
    behavior.up = win_resize_down
    behavior.down = win_resize_up
  else
    behavior.up = win_resize_up
    behavior.down = win_resize_down
  end
  
  return behavior
end

local function execute_command(key_char, mode)
  local behavior = {}
  
  if mode == 'resize' then
    behavior = get_resize_behavior()
  elseif mode == 'move' then
    behavior = {
      left = win_move_left,
      down = win_move_down,
      up = win_move_up,
      right = win_move_right
    }
  elseif mode == 'focus' then
    behavior = {
      left = win_focus_left,
      down = win_focus_down,
      up = win_focus_up,
      right = win_focus_right
    }
  end
  
  if key_char == config.keycode_left then
    behavior.left()
  elseif key_char == config.keycode_down then
    behavior.down()
  elseif key_char == config.keycode_up then
    behavior.up()
  elseif key_char == config.keycode_right then
    behavior.right()
  end
end

local function start_winresizer_mode(mode)
  mode = mode or config.start_mode
  
  if vim.fn.has('gui_running') == 0 then
    local saved_more = vim.o.more
    local saved_cmdheight = vim.o.cmdheight
    
    vim.o.more = false
    vim.o.cmdheight = 2
    
    vim.api.nvim_echo({{'-- WINRESIZER --', 'ModeMsg'}}, false, {})
    vim.api.nvim_echo({{'hjkl: resize, Enter: apply, q: cancel', 'MoreMsg'}}, false, {})
    
    while true do
      local key_char = get_char()
      
      if key_char == config.keycode_finish then
        vim.api.nvim_echo({{'', ''}}, false, {})
        break
      elseif key_char == config.keycode_cancel then
        vim.api.nvim_echo({{'', ''}}, false, {})
        break
      end
      
      execute_command(key_char, mode)
      vim.cmd('redraw')
    end
    
    vim.o.more = saved_more
    vim.o.cmdheight = saved_cmdheight
    vim.cmd('redraw!')
  else
    vim.notify('WinResizer: GUI mode not fully implemented yet', vim.log.levels.WARN)
  end
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', defaults, opts or {})
  
  vim.keymap.set('n', config.start_key, function()
    start_winresizer_mode()
  end, { desc = 'Start WinResizer' })
  
  vim.api.nvim_create_user_command('WinResizerStartResize', function()
    start_winresizer_mode('resize')
  end, {})
  
  vim.api.nvim_create_user_command('WinResizerStartMove', function()
    start_winresizer_mode('move')
  end, {})
  
  vim.api.nvim_create_user_command('WinResizerStartFocus', function()
    start_winresizer_mode('focus')
  end, {})
end

return M