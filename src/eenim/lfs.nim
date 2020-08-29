import os, times
import lua

proc Lchdir(L: PState): cint {.cdecl.} =
  let newDir = $(L.checkstring(1))

  try:
    setCurrentDir(newDir)
    L.pushbool(true)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc Lcurrentdir(L: PState): cint {.cdecl.} =
  L.pushnimstring(getCurrentDir())
  result = 1

proc Lmkdir(L: PState): cint {.cdecl.} =
  let dir = $(L.checkstring(1))

  try:
    createDir(dir)
    L.pushbool(true)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc Lrmdir(L: PState): cint {.cdecl.} =
  let dir = $(L.checkstring(1))

  try:
    removeDir(dir)
    L.pushbool(true)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc Lattributes(L: PState): cint {.cdecl.} =
  let filepath = $(L.checkstring(1))
  let request_name = $(L.checkstring(2))

  let fileinfo = getFileInfo(filepath)
  if request_name == "mode":
    case fileinfo.kind
    of pcFile:
      L.pushliteral("file")
      result = 1
    of pcDir:
      L.pushliteral("directory")
      result = 1
    of pcLinkToFile, pcLinkToDir:
      L.pushliteral("link")
      result = 1
  elif request_name == "size":
    L.pushnumber(fileinfo.size.lua_Number)
    result = 1
  elif request_name == "modification":
    L.pushnumber(fileinfo.lastWriteTime.toUnix().lua_Number)
    result = 1
  elif request_name == "access":
    L.pushnumber(fileinfo.lastAccessTime.toUnix().lua_Number)
    result = 1
  elif request_name == "change":
    L.pushnumber(fileinfo.creationTime.toUnix().lua_Number)
    result = 1

proc Lwalk_dir(L: PState): cint {.cdecl.} =
  let dir = $(L.checkstring(1))
  let relative = if L.isboolean(2): L.tobool(2) else: false

  var i = 1
  L.newtable()
  for kind, path in walkDir(dir, relative):
    L.pushnimstring(path)
    L.rawseti(-2, i.lua_Integer)
    i += 1
  result = 1

proc Lwalk_dir_rec(L: PState): cint {.cdecl.} =
  let dir = $(L.checkstring(1))
  let relative = if L.isboolean(2): L.tobool(2) else: false

  var i = 1
  L.newtable()
  for path in walkDirRec(dir, relative=relative):
    L.pushnimstring(path)
    L.rawseti(-2, i.lua_Integer)
    i += 1
  result = 1

proc Lexists_file(L: PState): cint {.cdecl.} =
  let filepath = $(L.checkstring(1))
  L.pushbool(existsFile(filepath))
  result = 1

proc Lexists_dir(L: PState): cint {.cdecl.} =
  let dir = $(L.checkstring(1))
  L.pushbool(existsDir(dir))
  result = 1

proc Lcopy_file(L: PState): cint {.cdecl.} =
  let source = $(L.checkstring(1))
  let dest = $(L.checkstring(2))

  try:
    copyFile(source, dest)
    L.pushbool(true)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc Lmove_file(L: PState): cint {.cdecl.} =
  let source = $(L.checkstring(1))
  let dest = $(L.checkstring(2))

  try:
    moveFile(source, dest)
    L.pushbool(true)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc Lremove_file(L: PState): cint {.cdecl.} =
  let filepath = $(L.checkstring(1))

  try:
    removeFile(filepath)
    L.pushbool(true)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc Lcopy_dir(L: PState): cint {.cdecl.} =
  let source = $(L.checkstring(1))
  let dest = $(L.checkstring(2))

  try:
    copyDir(source, dest)
    L.pushbool(true)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc Lmove_dir(L: PState): cint {.cdecl.} =
  let source = $(L.checkstring(1))
  let dest = $(L.checkstring(2))

  try:
    moveDir(source, dest)
    L.pushbool(true)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc Lget_file_size(L: PState): cint {.cdecl.} =
  let filepath = $(L.checkstring(1))

  try:
    var sz = getFileSize(filepath)
    L.pushnumber(sz.lua_Number)
    result = 1
  except:
    L.pushnil()
    L.pushnimstring(getCurrentExceptionMsg())
    result = 2

proc luaopen_lfs*(L: PState): cint {.cdecl.} =
  var funcs = [
    luaL_Reg(name: "attributes", fn: Lattributes),
    luaL_Reg(name: "chdir", fn: Lchdir),
    luaL_Reg(name: "currentdir", fn: Lcurrentdir),
    luaL_Reg(name: "mkdir", fn: Lmkdir),
    luaL_Reg(name: "rmdir", fn: Lrmdir),
    # extra funs
    luaL_Reg(name: "walk_dir", fn: Lwalk_dir),
    luaL_Reg(name: "walk_dir_rec", fn: Lwalk_dir_rec),
    luaL_Reg(name: "exists_file", fn: Lexists_file),
    luaL_Reg(name: "exists_dir", fn: Lexists_dir),
    luaL_Reg(name: "copy_file", fn: Lcopy_file),
    luaL_Reg(name: "move_file", fn: Lmove_file),
    luaL_Reg(name: "remove_file", fn: Lremove_file),
    luaL_Reg(name: "copy_dir", fn: Lcopy_dir),
    luaL_Reg(name: "move_dir", fn: Lmove_dir),
    luaL_Reg(name: "get_file_size", fn: Lget_file_size),
    luaL_Reg(name: nil, fn: nil)
  ]
  L.lregister("lfs", cast[ptr luaL_reg](addr(funcs)))
  result = 1
