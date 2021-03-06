import windows/winlean

export winlean

type
  HWND* = Handle
  HMENU* = Handle
  HICON* = Handle
  HMODULE* = Handle

  WINUINT* = int32

  LPCSTR* = cstring
  LPWSTR* = WideCString
  LPCWSTR* = WideCString
  PCWSTR* = WideCString
  LPVOID* = pointer
  LPDWORD* = ptr DWORD

type
  NMHDR* {.final, pure.} = object
    hwndFrom*: HWND
    idFrom*: WINUINT
    code*: WINUINT

  RECT* {.final, pure.} = object
    left*: LONG
    top*: LONG
    right*: LONG
    bottom*: LONG

  PRECT* = ptr RECT
  LPRECT* = ptr RECT

const
  TRUE* = 1
  FALSE* = 0
  NULL* = 0

  DLL_PROCESS_ATTACH* = 1
  DLL_THREAD_ATTACH* = 2
  DLL_PROCESS_DETACH* = 0
  DLL_THREAD_DETACH* = 3

  WM_USER* = 1024

  MB_OK* = 0

proc OutputDebugStringA*(lpOutputString: cstring) {.
  importc: "OutputDebugStringA", dynlib: "kernel32", stdcall.}
