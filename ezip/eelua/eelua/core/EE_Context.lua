local ffi = require"ffi"
local eelua = require"eelua"
local base = require"eelua.core.base"

local C = ffi.C
local ffi_cast = ffi.cast
local send_message = base.send_message

local _M = {}
local mt = {
  __index = function(self, k)
    return _M[k]
  end
}

function _M:api_call(hwnd, msg, wparam, lparam)
  return C.SendMessageA(self.hMain, msg, wparam or 0, lparam or 0)
end

function _M:set_hook(name, func)
  return send_message(self.hMain, C.EEM_SETHOOK, name, ffi_cast("intptr_t", func))
end

ffi.metatype("EE_Context", mt)

return _M
