import eesdk
import lua, lua_helper, lfs, leelua

var
  L*: PState

proc run_eelua_init*(L: PState): cint {.cdecl.} =
  let eelua_init_filename = "./eelua/eelua_init.lua"
  result = L.luaH_dofile(eelua_init_filename)

proc initLua*(context: ptr EE_Context) =
  L = newstate()
  if not isNil(L.pointer):
    L.openlibs
    L.pop(L.luaopen_lfs())
    discard L.luaopen_eelua()
    L.pushlightuserdata(context)
    L.setfield(-2, "_ee_context")
    L.pop(1)
    discard L.run_eelua_init

proc deinitLua*() =
  if not isNil(L.pointer):
    L.close
