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

when defined(useWinUnicode):
  proc WC*(s: string): LPCWSTR =
    if s.len == 0: return cast[LPCWSTR](0)
    let x = newWideCString(s)
    result = cast[LPCWSTR](x)
else:
  template WC*(s: string): cstring = s.cstring

when defined(useWinUnicode):
  proc MessageBoxW*(hWnd: HWND, lpText: WideCString, lpCaption: WideCString, uType: WINUINT): cint {.
    importc: "MessageBoxW", dynlib: "user32", stdcall.}

proc MessageBoxA*(hWnd: HWND, lpText: cstring, lpCaption: cstring, uType: WINUINT): cint {.
  importc: "MessageBoxA", dynlib: "user32", stdcall.}

proc OutputDebugStringA*(lpOutputString: cstring) {.
  importc: "OutputDebugStringA", dynlib: "kernel32", stdcall.}
