local ffi = require"ffi"
local eelua = require"eelua"
local base = require"eelua.core.base"
local unicode = require"unicode"

local C = eelua.C
local ffi_new = ffi.new
local ffi_cast = ffi.cast
local send_message = base.send_message

ffi.cdef[[
typedef struct {
  HWND hwnd;
} EE_Document;
]]

local _M = {}
local mt = {
  __index = function(self, k)
    if k == "cursor" then
      return _M.get_caret_pos(self)
    end
    return _M[k]
  end
}

function _M.new(hwnd)
  return ffi_new("EE_Document", { hwnd })
end

function _M:get_caret_pos()
  local pos_ptr = ffi_new("EC_Pos[1]")
  send_message(self.hwnd, C.ECM_GETCARETPOS, pos_ptr)
  return pos_ptr[0].line + 1, pos_ptr[1].col + 1
end

function _M:getline(lnum)
  if lnum == "." then
    lnum = self.cursor
  end
  local wtext = ffi_cast("wchar_t*", send_message(self.hwnd, C.ECM_GETLINEBUF, lnum - 1))
  return unicode.w2a(wtext, C.lstrlenW(wtext))
end

function _M:get_fullpath()
  local wtext = ffi_cast("wchar_t*", send_message(self.hwnd, C.ECM_GETPATH))
  return unicode.w2a(wtext, C.lstrlenW(wtext))
end

ffi.metatype("EE_Document", mt)

return _M
