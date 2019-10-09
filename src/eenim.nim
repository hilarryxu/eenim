import
  eenimpkg/winapi, eenimpkg/eesdk

var
  gEEModule : HANDLE = NULL

proc NimMain() {.cdecl, importc.}

proc pluginInit(hModule: HMODULE) =
  gEEModule = hModule

proc pluginCleanUp() = discard

proc DllMain(hModule: HANDLE, reasonForCall: DWORD, lpReserved: LPVOID): WINBOOL {.stdcall, exportc, dynlib.} =
  case reasonForCall
  of DLL_PROCESS_ATTACH:
    NimMain()
    pluginInit(hModule)
  of DLL_PROCESS_DETACH:
    pluginCleanUp()
    discard
  of DLL_THREAD_ATTACH:
    discard
  of DLL_THREAD_DETACH:
    discard
  else:
    discard
  result = TRUE

proc EE_PluginInit(context: ptr EE_Context): DWORD {.cdecl, exportc, dynlib.} =
  discard messageBox(NULL, "eenim", "About", MB_OK)
  return 0
