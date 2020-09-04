local ffi = require"ffi"
local string = require"string"
local eelua = require"eelua"

local C = ffi.C
local ffi_new = ffi.new
local ffi_str = ffi.string
local ffi_cast = ffi.cast
local str_fmt = string.format

local str_buf_size = 4096
local str_buf
local size_ptr
local errmsg
local c_buf_type = ffi.typeof("char[?]")

local ok, new_tab = pcall(require, "table.new")
if not ok then
  new_tab = function (narr, nrec) return {} end
end

local clear_tab
ok, clear_tab = pcall(require, "table.clear")
if not ok then
  local pairs = pairs
  clear_tab = function (tab)
    for k, _ in pairs(tab) do
      tab[k] = nil
    end
  end
end

local _M = new_tab(0, 20)

_M.version = "0.1.0"
_M.new_tab = new_tab
_M.clear_tab = clear_tab

function _M.get_errmsg_ptr()
  if not errmsg then
    errmsg = ffi_new("char*[1]")
  end

  return errmsg
end

function _M.get_string_buf_size()
  return str_buf_size
end

function _M.get_size_ptr()
  if not size_ptr then
    size_ptr = ffi_new("size_t[1]")
  end

  return size_ptr
end

function _M.get_string_buf(size, must_alloc)
  size = size or -1
  if size > str_buf_size or must_alloc then
    return ffi_new(c_buf_type, size)
  end

  if not str_buf then
    str_buf = ffi_new(c_buf_type, str_buf_size)
  end

  return str_buf
end

function _M.newobj(obj)
  if ffi_cast("void*", obj) > nil then
    return obj
  else
    return nil, [[it's a NULL cdata]]
  end
end

function _M.ptr2number(p)
  return tonumber(ffi_cast("intptr_t", p))
end

ffi.cdef[[
typedef uint8_t uchar;

typedef void* HANDLE;
typedef HANDLE HWND;
typedef HANDLE HMENU;
typedef HANDLE HMODULE;

typedef uint32_t DWORD;
typedef uint32_t UINT;
typedef intptr_t LONG_PTR;
typedef LONG_PTR WPARAM;
typedef LONG_PTR LPARAM;
typedef LONG_PTR LRESULT;

typedef struct {
  HWND hMain;
  HWND hToolBar;
  HWND hStatusBar;
  HWND hClient;
  HWND hStartPage;
  HMENU hMainMenu;
  HMENU hPluginMenu;
  DWORD* pCommand;
  DWORD dwCommand;
  DWORD dwVersion;
  DWORD dwBuild;
  DWORD dwLCID;
  HMODULE hModule;
} EE_Context;

LRESULT SendMessageA(
  HWND   hWnd,
  UINT   Msg,
  WPARAM wParam,
  LPARAM lParam
);

int lstrlenW(
  const wchar_t* lpString
);

DWORD GetModuleFileNameA(
  HMODULE hModule,
  char* lpFilename,
  DWORD nSize
);

typedef int (__stdcall *pfnOnRunningCommand)(const wchar_t* command, int length);
typedef int (*pfnOnAppMessage)(UINT uMsg, WPARAM wp, LPARAM lp);

static const int WM_USER = 1024;
static const int EEM_GETACTIVETEXT = WM_USER + 3000;
static const int EEM_SETHOOK = WM_USER + 3003;

static const int EEHOOK_RUNCOMMAND = 13;
static const int EEHOOK_APPMSG = 7;
]]

eelua.C = C

function eelua.printf(fmt, ...)
  eelua.dprint(str_fmt(fmt, ...))
end

function _M.send_message(hwnd, msg, wparam, lparam)
  return C.SendMessageA(hwnd, msg, wparam or 0, lparam or 0)
end

return _M
