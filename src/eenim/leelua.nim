import lua, winapi

when sizeof(int) > 4:
  const isX64 = true
else:
  const isX64 = false

proc Leelua_dprint(L: PState): cint {.cdecl.} =
  let msg = L.checkstring(1)
  OutputDebugStringA(msg)


proc luaopen_eelua*(L: PState): cint {.cdecl.} =
  var funcs = [
    luaL_Reg(name: "dprint", fn: Leelua_dprint),
    luaL_Reg(name: nil, fn: nil)
  ]
  L.lregister("eelua", cast[ptr luaL_reg](addr(funcs)))
  L.pushbool(isX64)
  L.setfield(-2, "x64")
  when defined(release):
    L.pushbool(false)
    L.setfield(-2, "DEBUG")
  else:
    L.pushbool(true)
    L.setfield(-2, "DEBUG")
  result = 1
