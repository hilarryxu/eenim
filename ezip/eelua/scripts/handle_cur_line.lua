local string = require"string"
local path = require"path"

local str_fmt = string.format

local dir_mirserver = "D:/Mirserver"

local doc = App.active_doc
local text = doc:getline(".")
local parts = string.explode(text, "[%s]+")
if #parts >= 7 then
  local npc_fn = path.join(dir_mirserver, "Mir200/Envir/Market_Def",
                           str_fmt("%s-%s.txt", parts[1], parts[2]))
  -- App:output_line(str_fmt("npc_fn: %s", npc_fn))
  App:open_doc(npc_fn, 936)
end
