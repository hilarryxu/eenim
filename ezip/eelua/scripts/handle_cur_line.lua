local ffi = require"ffi"
local base = require"eelua.core.base"
local unicode = require"unicode"

local ffi_new = ffi.new
local ffi_cast = ffi.cast
local C = eelua.C
local _p = eelua.printf
local send_message = base.send_message

local doc_hwnd = ffi_cast("HWND", send_message(ee_context.hMain, C.EEM_GETACTIVETEXT))

local pos_ptr = ffi_new("EC_Pos[1]")
send_message(doc_hwnd, C.ECM_GETCARETPOS, pos_ptr)
local pos = pos_ptr[0]
_p("handle_cur_line: %s,%s", pos.line, pos.col)

local wtext = ffi_cast("wchar_t*",  send_message(doc_hwnd, C.ECM_GETLINEBUF, pos.line))
local text = unicode.w2a(wtext, C.lstrlenW(wtext))
_p("text: %s", text)
