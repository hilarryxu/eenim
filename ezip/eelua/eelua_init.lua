local package = require"package"
package.path = package.path .. [[;.\eelua\?.lua]]

local ffi = require"ffi"
local string = require"string"
local eelua = require"eelua"
require"eelua.core"
require"eelua.stdext"
require"eelua.utils"
local print_r = require"print_r"
local unicode = require"unicode"

local C = ffi.C
local ffi_new = ffi.new
local ffi_str = ffi.string
local ffi_cast = ffi.cast
local str_fmt = string.format
local _p = eelua.printf

local ee_context = ffi_cast("EE_Context*", eelua._ee_context)

OnRunningCommand = ffi_cast("pfnOnRunningCommand", function (wcommand, wlen)
  _p("command: %s", unicode.w2a(wcommand, wlen))
  return 0
end)

ee_context:set_hook(C.EEHOOK_RUNCOMMAND, OnRunningCommand)
