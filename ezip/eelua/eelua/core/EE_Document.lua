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
    elseif k == "linenr" then
      return _M.get_linenr(self)
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
  return { pos_ptr[0].line, pos_ptr[1].col }
end

function _M:getline(lnum)
  if lnum == "." then
    lnum = self.cursor[0]
  end
  local wtext = ffi_cast("wchar_t*", send_message(self.hwnd, C.ECM_GETLINEBUF, lnum))
  return unicode.w2a(wtext, C.lstrlenW(wtext))
end

function _M:get_fullpath()
  local wtext = ffi_cast("wchar_t*", send_message(self.hwnd, C.ECM_GETPATH))
  return unicode.w2a(wtext, C.lstrlenW(wtext))
end

function _M:gettext(begin_pos, end_pos)
  begin_pos = begin_pos or { 0, 0 }
  end_pos = end_pos or { C.INT_MAX, C.INT_MAX }

  local sel_ptr = ffi_new("EC_SelInfo[1]")
  sel_ptr[0].bpos_line = begin_pos[1]
  sel_ptr[0].bpos_col = begin_pos[2]
  sel_ptr[0].epos_line = end_pos[1]
  sel_ptr[0].epos_col = end_pos[2]
  sel_ptr[0].lpBuffer = nil
  sel_ptr[0].nEol = 0

  local wlen = tonumber(send_message(self.hwnd, C.ECM_GETTEXT, sel_ptr))

  local strbuf = base.get_string_buf((wlen + 3) * 2)
  sel_ptr[0].lpBuffer = ffi_cast("wchar_t*", strbuf)
  send_message(self.hwnd, C.ECM_GETTEXT, sel_ptr)
  return unicode.w2a(sel_ptr[0].lpBuffer, wlen)
end

function _M:delete(begin_pos, end_pos)
  begin_pos = begin_pos or { 0, 0 }
  end_pos = end_pos or { C.INT_MAX, C.INT_MAX }

  local bpos_ptr = ffi_new("EC_Pos[1]")
  bpos_ptr[0].line = begin_pos[1]
  bpos_ptr[0].col = begin_pos[2]
  local epos_ptr = ffi_new("EC_Pos[1]")
  epos_ptr[0].line = end_pos[1]
  epos_ptr[0].col = end_pos[2]

  send_message(self.hwnd, C.ECM_DELETETEXT, bpos_ptr, epos_ptr)
end

function _M:insert(text)
  local wtext, wlen = unicode.a2w(text)
  local insert_text_ptr = ffi_new("EC_InsertText[1]")
  insert_text_ptr[0].wtext = wtext
  insert_text_ptr[0].wlen = wlen

  send_message(self.hwnd, C.ECM_INSERTTEXT, 0, insert_text_ptr)
end

function _M:insert_at(line, col, text)
  local pos_ptr = ffi_new("EC_Pos[1]")
  pos_ptr[0].line = line
  pos_ptr[0].col = col

  local wtext, wlen = unicode.a2w(text)
  local insert_text_ptr = ffi_new("EC_InsertText[1]")
  insert_text_ptr[0].wtext = wtext
  insert_text_ptr[0].wlen = wlen

  send_message(self.hwnd, C.ECM_INSERTTEXT, pos_ptr, insert_text_ptr)
end

function _M:get_linenr()
  return tonumber(send_message(self.hwnd, C.ECM_GETLINECNT))
end

function _M:gotoline(line)
  send_message(self.hwnd, C.ECM_JUMPTOLINE, line)
end

function _M:redraw()
  send_message(self.hwnd, C.ECM_REDRAW)
end

function _M:send_command(cmd)
  send_message(self.hwnd, C.WM_COMMAND, cmd)
end

function _M:get_sel_type()
  return tonumber(send_message(self.hwnd, C.ECM_HASSEL))
end

function _M:setsel(begin_pos, end_pos)
  begin_pos = begin_pos or { 0, 0 }
  end_pos = end_pos or { C.INT_MAX, C.INT_MAX }

  local bpos_ptr = ffi_new("EC_Pos[1]")
  bpos_ptr[0].line = begin_pos[1]
  bpos_ptr[0].col = begin_pos[2]
  local epos_ptr = ffi_new("EC_Pos[1]")
  epos_ptr[0].line = end_pos[1]
  epos_ptr[0].col = end_pos[2]

  send_message(self.hwnd, C.ECM_SETSEL, bpos_ptr, epos_ptr)
end

ffi.metatype("EE_Document", mt)

return _M
