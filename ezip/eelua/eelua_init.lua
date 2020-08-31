local package = require"package"
package.path = package.path .. [[;.\eelua\?.lua]]

local ffi = require"ffi"
local string = require"string"
local eelua = require"eelua"
local print_r = require"print_r"

local C = ffi.C
local ffi_new = ffi.new
local ffi_str = ffi.string
local ffi_cast = ffi.cast
local str_fmt = string.format

ffi.cdef[[
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
]]

function eelua.printf(fmt, ...)
  eelua.dprint(str_fmt(fmt, ...))
end

local _p = eelua.printf

local WM_USER = 1024
local EEM_GETACTIVETEXT = WM_USER + 3000

local ee_context = ffi_cast("EE_Context*", eelua._ee_context)

function send_message(hwnd, msg, wparam, lparam)
  return C.SendMessageA(hwnd, msg, wparam or 0, lparam or 0)
end

local doc_hwnd = send_message(ee_context.hMain, EEM_GETACTIVETEXT, 0, 0)
_p("doc_hwnd: %s", doc_hwnd)

_p("hMain: %s", ee_context.hMain)
_p("pCommand: %s", ee_context.pCommand)
_p("dwCommand: %s", ee_context.dwCommand)
_p("dwVersion: %s", ee_context.dwVersion)
_p("dwBuild: %s", ee_context.dwBuild)
_p("hModule: %s", ee_context.hModule)

_p("int_sz: %d", ffi.sizeof("int"))
_p("void*_sz: %d", ffi.sizeof("void*"))
