local package = require"package"
package.path = package.path .. [[;.\eelua\?.lua]]

local ffi = require"ffi"
local string = require"string"
local eelua = require"eelua"
require"eelua.core"
require"eelua.stdext"
require"eelua.utils"
local base = require"eelua.core.base"
local print_r = require"print_r"
local unicode = require"unicode"
local path = require"path"

local C = ffi.C
local ffi_new = ffi.new
local ffi_str = ffi.string
local ffi_cast = ffi.cast
local str_fmt = string.format
local _p = eelua.printf

local ee_context = ffi_cast("EE_Context*", eelua._ee_context)
local app_path_strbuf = base.get_string_buf()
C.GetModuleFileNameA(ee_context.hModule, app_path_strbuf, base.get_string_buf_size())
local app_path = path.getdirectory(path.getabsolute(ffi_str(app_path_strbuf)))
eelua.app_path = app_path

OnDoFile = function(ctx, rect, wtext)
  local text = unicode.w2a(wtext, C.lstrlenW(wtext))
  _p("OnDoFile('%s')", text)
  local params = string.explode(text, "^^", true)
  local nparams = #params
  assert(nparams > 0)

  local filepath = path.join(app_path, params[1])
  local okay, chunk = pcall(dofile, filepath)
  if not okay then
    _p("ERR: %s", chunk)
    return
  end
  if nparams > 1 then
    local func = chunk(params[2])
    func(unpack(select(3, unpack(params))))
  end
end

OnRunningCommand = ffi_cast("pfnOnRunningCommand", function(wcommand, wlen)
  _p("command: %s", unicode.w2a(wcommand, wlen))
  return 0
end)

ee_context:set_hook(C.EEHOOK_RUNCOMMAND, OnRunningCommand)
