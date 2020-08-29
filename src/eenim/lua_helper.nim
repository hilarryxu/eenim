import strutils
import lua, winapi

proc msghandler(L: PState): cint {.cdecl.} =
  var msg = L.checkstring(1)
  var msgstr = $msg
  if msg.isNil:
    if L.callmeta(1, "__tostring") == 1 and L.luatype(-1) == LUA_TSTRING:
      return 1
    else:
      msgstr = $(L.pushfstring("(error object is a %s value)", L.ltypename(1)))
  traceback(L, L, msgstr, 1)
  result = 1

proc luaH_report*(L: PState; status: cint): cint =
  # 栈顶为结果列表或错误消息
  if status != LUA_OK:
    let msg = L.tostring(-1)
    OutputDebugStringA("[eelua] ERR: $1" % $msg)
    L.pop(1)  # 移除错误消息
  result = status

proc luaH_docall*(L: PState; narg, nres: cint; extramsg: string = ""): cint =
  # 栈顶是函数加参数列表
  var base = L.gettop() - narg  # func位置
  L.pushcfunction(msghandler)
  L.insert(base)  # 插入msghandler
  result = L.pcall(narg, nres, base)  # 调用函数，栈顶为结果列表或错误消息
  L.remove(base)  # 移除msghandler

proc luaH_dochunk*(L: PState; status: cint): cint =
  # 栈顶是chunk函数或者错误信息
  # 成功栈顶为返回结果列表
  # 失败时恢复为调用前（错误消息已移除）
  var ret = status
  if ret == LUA_OK:
    ret = L.luaH_docall(0, 0)
  result = L.luaH_report(ret)

proc luaH_dofile*(L: PState; fname: string): cint =
  # 已保持栈平衡
  result = L.luaH_dochunk(L.loadfile(fname))

proc luaH_dostring*(L: PState; s, name: string): cint =
  # 已保持栈平衡
  result = L.luaH_dochunk(L.loadbuffer(s, name))
