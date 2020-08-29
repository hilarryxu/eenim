import
  eenim/winapi, eenim/eesdk,
  eenim/init_lua

var
  g_EEModule : Handle = NULL

proc NimMain() {.cdecl, importc.}

proc dllInit(hModule: Handle) =
  g_EEModule = hModule

proc dllCleanup() = discard

proc DllMain(hModule: Handle, reasonForCall: DWORD,
             lpReserved: LPVOID): WINBOOL
            {.stdcall, exportc, dynlib.} =
  case reasonForCall
  of DLL_PROCESS_ATTACH:
    NimMain()
    dllInit(hModule)
  of DLL_PROCESS_DETACH:
    dllCleanup()
    discard
  of DLL_THREAD_ATTACH:
    discard
  of DLL_THREAD_DETACH:
    discard
  else:
    discard
  result = TRUE

proc EE_PluginInit(context: ptr EE_Context): DWORD {.cdecl, exportc, dynlib.} =
  # discard messageBox(NULL, "eenim", "About", MB_OK)
  initLua(context)
  return 0

proc EE_PluginUninit(): DWORD {.cdecl, exportc, dynlib.} =
  deinitLua()
  return 0
