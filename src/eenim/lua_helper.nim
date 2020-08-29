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
  # ջ��Ϊ����б�������Ϣ
  if status != LUA_OK:
    let msg = L.tostring(-1)
    OutputDebugStringA("[eelua] ERR: $1" % $msg)
    L.pop(1)  # �Ƴ�������Ϣ
  result = status

proc luaH_docall*(L: PState; narg, nres: cint; extramsg: string = ""): cint =
  # ջ���Ǻ����Ӳ����б�
  var base = L.gettop() - narg  # funcλ��
  L.pushcfunction(msghandler)
  L.insert(base)  # ����msghandler
  result = L.pcall(narg, nres, base)  # ���ú�����ջ��Ϊ����б�������Ϣ
  L.remove(base)  # �Ƴ�msghandler

proc luaH_dochunk*(L: PState; status: cint): cint =
  # ջ����chunk�������ߴ�����Ϣ
  # �ɹ�ջ��Ϊ���ؽ���б�
  # ʧ��ʱ�ָ�Ϊ����ǰ��������Ϣ���Ƴ���
  var ret = status
  if ret == LUA_OK:
    ret = L.luaH_docall(0, 0)
  result = L.luaH_report(ret)

proc luaH_dofile*(L: PState; fname: string): cint =
  # �ѱ���ջƽ��
  result = L.luaH_dochunk(L.loadfile(fname))

proc luaH_dostring*(L: PState; s, name: string): cint =
  # �ѱ���ջƽ��
  result = L.luaH_dochunk(L.loadbuffer(s, name))
