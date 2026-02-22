local M = {}

M.parsers = {}
M.servers = {}


-- use LuaFileSystem (builtin vim.loop) to scan the langs folder
local uv = vim.loop
local base = vim.fn.stdpath("config") .. "/lua/langs"
local function scan_dir(dir, prefix)
  local handle = uv.fs_scandir(dir)
  if not handle then return end

  while true do
    local name, typ = uv.fs_scandir_next(handle)
    if not name then break end

    local full = dir .. "/" .. name

    if typ == "file" and name:match("%.lua$") then
      local module = prefix .. "." .. name:gsub("%.lua$", "")
      local ok, conf = pcall(require, module)
      if ok and type(conf) == "table" then

        if conf.parsers then
          vim.list_extend(M.parsers, conf.parsers)
        end

        if conf.servers then
          vim.list_extend(M.servers, conf.servers)
        end
      end
    end
  end
end

scan_dir(base, "langs")

return M
