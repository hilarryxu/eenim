# luajit-2.1.0-beta2

import strutils

const
  LUA_VERSION_MAJOR* = "5"
  LUA_VERSION_MINOR* = "1"
  LUA_VERSION_NUM* = 501
  LUA_VERSION_RELEASE* = "4"
  LUA_VERSION* = "Lua " & LUA_VERSION_MAJOR & "." & LUA_VERSION_MINOR
  LUA_RELEASE* = LUA_VERSION & "." & LUA_VERSION_RELEASE
  LUA_COPYRIGHT* = LUA_RELEASE & " Copyright (C) 1994-2018 Lua.org, PUC-Rio"
  LUA_AUTHORS* = "R. Ierusalimschy, L. H. de Figueiredo, W. Celes"

#{.deadCodeElim: on.}

const
  LIB_NAME* = "lua51.dll"

when not declared(csize_t):
  type
    csize_t* = csize

const
  # mark for precompiled code ('<esc>Lua')
  LUA_SIGNATURE* = "\x1BLua"

  # option for multiple returns in 'lua_pcall' and 'lua_call'
  LUA_MULTRET* = (-1)

#
#* pseudo-indices
#

#const
#  LUAI_MAXSTACK = 65500
#  LUAI_MAXCSTACK = 8000

# reserve some space for error handling
const
  LUA_REGISTRYINDEX* = -10000
  LUA_ENVIRONINDEX* = -10001
  LUA_GLOBALSINDEX* = -10002

proc upvalueindex*(i: int): int {.inline.} = LUA_GLOBALSINDEX - i

# thread status
type TThreadStatus* {.size:sizeof(cint).} = enum
  Thread_OK = 0, Thread_Yield, Thread_ErrRun, Thread_ErrSyntax,
  Thread_ErrMem, Thread_ErrErr

const
  LUA_OK* = 0
  LUA_YIELD* = 1
  LUA_ERRRUN* = 2
  LUA_ERRSYNTAX* = 3
  LUA_ERRMEM* = 4
  LUA_ERRERR* = 5

type
  PState* = distinct pointer
  lua_State* = PState
  TCFunction* = proc (L: PState): cint {.cdecl.}

  #* functions that read/write blocks when loading/dumping Lua chunks
  TReader* = proc (L: PState; ud: pointer; sz: var csize_t): cstring {.cdecl.}
  TWriter* = proc (L: PState; p: pointer; sz: csize_t; ud: pointer): cint {.cdecl.}

  #* prototype for memory-allocation functions
  TAlloc* = proc (ud, p: pointer; osize, nsize: csize_t): pointer {.cdecl.}

#* basic types
const
  LUA_TNONE* = (-1)
  LUA_TNIL* = 0
  LUA_TBOOLEAN* = 1
  LUA_TLIGHTUSERDATA* = 2
  LUA_TNUMBER* = 3
  LUA_TSTRING* = 4
  LUA_TTABLE* = 5
  LUA_TFUNCTION* = 6
  LUA_TUSERDATA* = 7
  LUA_TTHREAD* = 8

type
  LUA_TYPE* = enum
    LNONE = -1, LNIL, LBOOLEAN, LLIGHTUSERDATA, LNUMBER,
    LSTRING, LTABLE, LFUNCTION, LUSERDATA, LTHREAD

# minimum Lua stack available to a C function
const
  LUA_MINSTACK* = 20

type
  lua_Number* = float64   # type of numbers in Lua
  lua_Integer* = cint     # ptrdiff_t \ type for integer functions

{.push callconv: cdecl, dynlib: LIB_NAME.} # importc: "lua_$1" was not allowed?
{.pragma: ilua, importc: "lua_$1".} # lua.h
{.pragma: iluaLIB, importc: "lua$1".} # lualib.h
{.pragma: iluaL, importc: "luaL_$1".} # lauxlib.h

#
#* state manipulation
#
proc newstate*(f: TAlloc; ud: pointer): PState {.ilua.}
proc close*(L: PState) {.ilua.}
proc newthread*(L: PState): PState {.ilua.}
proc atpanic*(L: PState; panicf: TCFunction): TCFunction {.ilua.}

#
#* basic stack manipulation
#
proc gettop*(L: PState): cint {.ilua.}
proc settop*(L: PState; idx: cint) {.ilua.}
proc pushvalue*(L: PState; idx: cint) {.ilua.}
proc remove*(L: PState; idx: cint) {.ilua.}
proc insert*(L: PState; idx: cint) {.ilua.}
proc replace*(L: PState; idx: cint) {.ilua.}
proc checkstack*(L: PState; sz: cint): cint {.ilua.}
proc xmove*(src: PState; dst: PState; n: cint) {.ilua.}


#
#* access functions (stack -> C)
#
proc isnumber*(L: PState; idx: cint): cint {.ilua.}
proc isstring*(L: PState; idx: cint): cint {.ilua.}
proc iscfunction*(L: PState; idx: cint): cint {.ilua.}
proc isuserdata*(L: PState; idx: cint): cint {.ilua.}
proc luatype*(L: PState; idx: cint): cint {.importc: "lua_type".}
proc typename*(L: PState; tp: cint): cstring {.ilua.}

proc equal*(L: PState; idx1: cint; idx2: cint): cint {.ilua.}
proc rawequal*(L: PState; idx1: cint; idx2: cint): cint {.ilua.}
proc lessthan*(L: PState; idx1: cint; idx2: cint): cint {.ilua.}

proc tonumber*(L: PState; idx: cint): lua_Number {.ilua.}
proc tointeger*(L: PState; idx: cint): lua_Integer {.ilua.}
proc toboolean*(L: PState; idx: cint): cint {.ilua.}
proc tolstring*(L: PState; idx: cint; len: ptr csize_t): cstring {.ilua.}
proc objlen*(L: PState; idx: cint): csize_t {.ilua.}
proc tocfunction*(L: PState; idx: cint): TCFunction {.ilua.}
proc touserdata*(L: PState; idx: cint): pointer {.ilua.}
proc tothread*(L: PState; idx: cint): PState {.ilua.}
proc topointer*(L: PState; idx: cint): pointer {.ilua.}


#
#* push functions (C -> stack)
#
proc pushnil*(L: PState) {.ilua.}
proc pushnumber*(L: PState; n: lua_Number) {.ilua.}
proc pushinteger*(L: PState; n: lua_Integer) {.ilua.}
proc pushlstring*(L: PState; s: cstring; len: csize_t): cstring {.ilua.}
proc pushstring*(L: PState; s: cstring): cstring {.ilua.}
proc pushvfstring*(L: PState; fmt: cstring): cstring {.varargs, ilua.}
proc pushfstring*(L: PState; fmt: cstring): cstring {.varargs, ilua.}
proc pushcclosure*(L: PState; fn: TCFunction; n: cint) {.ilua.}
proc pushboolean*(L: PState; b: cint) {.ilua.}
proc pushlightuserdata*(L: PState; p: pointer) {.ilua.}
proc pushthread*(L: PState): cint {.ilua.}

#
#* get functions (Lua -> stack)
#
proc gettable*(L: PState; idx: cint) {.ilua.}
proc getfield*(L: PState; idx: cint; k: cstring) {.ilua.}
proc rawget*(L: PState; idx: cint) {.ilua.}
proc rawgeti*(L: PState; idx: cint; n: lua_Integer) {.ilua.}
proc createtable*(L: PState; narr: cint; nrec: cint) {.ilua.}
proc newuserdata*(L: PState; sz: csize_t): pointer {.ilua.}
proc getmetatable*(L: PState; idx: cint): cint {.ilua.}
proc getfenv*(L: PState; idx: cint) {.ilua.}

#
#* set functions (stack -> Lua)
#
proc settable*(L: PState; idx: cint) {.ilua.}
proc setfield*(L: PState; idx: cint; k: cstring) {.ilua.}
proc rawset*(L: PState; idx: cint) {.ilua.}
proc rawseti*(L: PState; idx: cint; n: lua_Integer) {.ilua.}
proc setmetatable*(L: PState; objindex: cint): cint {.ilua.}
proc setfenv*(L: PState; idx: cint): cint {.ilua.}

#
#* 'load' and 'call' functions (load and run Lua code)
#
proc call*(L: PState; n, r: cint) {.ilua.}
proc pcall*(L: PState; nargs, nresults, errFunc: cint): cint {.ilua.}
proc cpcall*(L: PState, funca: TCFunction, ud: pointer): cint {.ilua.}

proc load*(L: PState; reader: TReader; dt: pointer; chunkname, mode: cstring): cint {.ilua.}
proc dump*(L: PState; writer: TWriter; data: pointer): cint {.ilua.}

#
#* coroutine functions
#
proc luayield*(L: PState, n: cint): cint {.ilua.}
proc resume*(L: PState; fromL: PState; narg: cint): cint {.ilua.}
proc status*(L: PState): cint {.ilua.}

#
#* garbage-collection function and options
#
const
  LUA_GCSTOP* = 0
  LUA_GCRESTART* = 1
  LUA_GCCOLLECT* = 2
  LUA_GCCOUNT* = 3
  LUA_GCCOUNTB* = 4
  LUA_GCSTEP* = 5
  LUA_GCSETPAUSE* = 6
  LUA_GCSETSTEPMUL* = 7
  LUA_GCISRUNNING* = 9

proc gc*(L: PState; what: cint; data: cint): cint {.ilua.}

proc getgccount*(L: PState): cint {.inline.} = L.gc(LUA_GCCOUNT, 0)

#
#* miscellaneous functions
#
proc error*(L: PState): cint {.ilua.}
proc next*(L: PState; idx: cint): cint {.ilua.}
proc concat*(L: PState; n: cint) {.ilua.}

proc getallocf*(L: PState; ud: ptr pointer): TAlloc {.ilua.}
proc setallocf*(L: PState; f: TAlloc; ud: pointer) {.ilua.}

#
#* ===============================================================
#* some useful macros
#* ===============================================================
#
proc pop*(L: PState; n: cint) {.inline.} = L.settop(-n - 1)

proc getglobal*(L: PState; k: cstring) {.inline.} = L.getfield(LUA_GLOBALSINDEX, k)
proc setglobal*(L: PState; k: cstring) {.inline.} = L.setfield(LUA_GLOBALSINDEX, k)

proc newtable*(L: PState) {.inline.} = L.createtable(0, 0)

proc pushcfunction*(L: PState; fn: TCfunction) {.inline.} = L.pushcclosure(fn, 0)

proc register*(L: PState, n: string, f :TCFunction) {.inline.} =
  L.pushcfunction(f); L.setglobal(n)

proc isfunction* (L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TFUNCTION

proc istable* (L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TTABLE

proc islightuserdata*(L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TLIGHTUSERDATA

proc luaisnil*(L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TNIL

proc isboolean*(L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TBOOLEAN

proc isthread* (L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TTHREAD

proc isnone* (L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TNONE

proc isnoneornil*(L: PState; n: cint): bool {.inline.} =
  L.luatype(n) <= 0

proc pushliteral*(L: PState, s: string): cstring {.inline, discardable.} =
  L.pushlstring(s, s.len.csize_t)

proc pushnimstring*(L: PState, s: string): cstring {.inline, discardable.} =
  L.pushlstring(s, s.len.csize_t)

proc pushbool*(L: PState; b: bool) {.inline.} =
  L.pushboolean(if b: 1 else: 0)

proc tostring*(L: PState, index: cint): cstring {.inline.} =
  L.tolstring(index, nil)

proc tonimstring*(L: PState; index: cint): string =
  var len: csize_t = 0
  var s = L.tolstring(index, addr(len))
  result = newString(len)
  copyMem(result.cstring, s, len)

proc tobool*(L: PState; index: cint): bool =
  result = if L.toboolean(index) == 1: true else: false

proc gettype*(L: PState, index: int): LUA_TYPE =
  result = LUA_TYPE(L.luatype(index.cint))

proc getregistry*(L: PState) {.inline.} =
  L.pushvalue(LUA_REGISTRYINDEX)


#
#* {======================================================================
#* Debug API
#* =======================================================================
#
#
#* Event codes
#
const
  LUA_HOOKCALL* = 0
  LUA_HOOKRET* = 1
  LUA_HOOKLINE* = 2
  LUA_HOOKCOUNT* = 3
  LUA_HOOKTAILCALL* = 4
#
#* Event masks
#
const
  LUA_MASKCALL* = (1 shl LUA_HOOKCALL)
  LUA_MASKRET* = (1 shl LUA_HOOKRET)
  LUA_MASKLINE* = (1 shl LUA_HOOKLINE)
  LUA_MASKCOUNT* = (1 shl LUA_HOOKCOUNT)
# activation record


#@@ LUA_IDSIZE gives the maximum size for the description of the source
#@* of a function in debug information.
#* CHANGE it if you want a different size.
#
const
  LUA_IDSIZE* = 60

# Functions to be called by the debugger in specific events
type
  TDebug* {.pure, final.} = object
    event*: cint
    name*: cstring        # (n)
    namewhat*: cstring    # (n) 'global', 'local', 'field', 'method'
    what*: cstring        # (S) 'Lua', 'C', 'main', 'tail'
    source*: cstring      # (S)
    currentline*: cint    # (l)
    nups*: cint           # (u) number of upvalues
    linedefined*: cint
    lastlinedefined*: cint
    short_src*: array[LUA_IDSIZE, char] # (S) \ # private part
    i_ci: cint # ptr CallInfo   # active function
  PDebug* = ptr TDebug

  lua_Hook* = proc (L: PState; ar: PDebug) {.cdecl.}

proc getstack*(L: PState; level: cint; ar: PDebug): cint {.ilua.}
proc getinfo*(L: PState; what: cstring; ar: PDebug): cint {.ilua.}
proc getlocal*(L: PState; ar: PDebug; n: cint): cstring {.ilua.}
proc setlocal*(L: PState; ar: PDebug; n: cint): cstring {.ilua.}
proc getupvalue*(L: PState; funcindex: cint; n: cint): cstring {.ilua.}
proc setupvalue*(L: PState; funcindex: cint; n: cint): cstring {.ilua.}
proc sethook*(L: PState; fn: lua_Hook; mask: cint; count: cint): cint {.ilua.}
proc gethook*(L: PState): lua_Hook {.ilua.}
proc gethookmask*(L: PState): cint {.ilua.}
proc gethookcount*(L: PState): cint {.ilua.}

# From Lua 5.2
proc upvalueid*(L: PState; fidx: cint; n: cint): pointer {.ilua.}
proc upvaluejoin*(L: PState; fidx1: cint; n1: cint; fidx2: cint; n2: cint) {.ilua.}

#
#* $Id: lualib.h,v 1.45.1.1 2017/04/19 17:20:42 roberto Exp $
#* Lua standard libraries
#* See Copyright Notice in lua.h
#

proc open_base*(L: PState): cint {.iluaLIB.}
const
  LUA_COLIBNAME* = "coroutine"
proc open_coroutine*(L: PState): cint {.iluaLIB.}
const
  LUA_TABLIBNAME* = "table"
proc open_table*(L: PState): cint {.iluaLIB.}
const
  LUA_IOLIBNAME* = "io"
proc open_io*(L: PState): cint {.iluaLIB.}
const
  LUA_OSLIBNAME* = "os"
proc open_os*(L: PState): cint {.iluaLIB.}
const
  LUA_STRLIBNAME* = "string"
proc open_string*(L: PState): cint {.iluaLIB.}
const
  LUA_FFILIBNAME* = "ffi"
proc open_ffi*(L: PState): cint {.iluaLIB.}
const
  LUA_BITLIBNAME* = "bit"
proc open_bit*(L: PState): cint {.iluaLIB.}
const
  LUA_MATHLIBNAME* = "math"
proc open_math*(L: PState): cint {.iluaLIB.}
const
  LUA_DBLIBNAME* = "debug"
proc open_debug*(L: PState): cint {.iluaLIB.}
const
  LUA_LOADLIBNAME* = "package"
proc open_package*(L: PState): cint {.iluaLIB.}

# open all previous libraries
proc openlibs*(L: PState) {.iluaL.}

when not defined(lua_assert):
  template lua_assert*(x: typed) =
    (cast[nil](0))


#
#* $Id: lauxlib.h,v 1.131.1.1 2017/04/19 17:20:42 roberto Exp $
#* Auxiliary functions for building Lua libraries
#* See Copyright Notice in lua.h
#

# extra error code for `luaL_load'
const
  LUA_ERRFILE* = LUA_ERRERR + 1 # (LUA_ERRERR + 1)

type
  luaL_Reg* {.pure, final.} = object
    name*: cstring
    fn*: TCFunction

### IMPORT FROM "luaL_$1"
proc lregister*(L: PState; libname: cstring; L2: ptr luaL_Reg) {.importc: "luaL_register".}
proc getmetafield*(L: PState; obj: cint; e: cstring): cint {.iluaL.}
proc callmeta*(L: PState; obj: cint; e: cstring): cint {.iluaL.}
#proc tolstring*(L: PState; idx: cint; len: ptr csize_t): cstring {.importc: "luaL_tolstring".}
# ^ duplicate?
proc typerror*(L: PState; narg: cint; tname: cstring): cint {.iluaL.}
proc argerror*(L: PState; numarg: cint; extramsg: cstring): cint {.iluaL.}
proc checklstring*(L: PState; arg: cint; len: ptr csize_t): cstring {.iluaL.}
proc optlstring*(L: PState; arg: cint; def: cstring; len: ptr csize_t): cstring {.iluaL.}
proc checknumber*(L: PState; arg: cint): lua_Number {.iluaL.}
proc optnumber*(L: PState; arg: cint; def: lua_Number): lua_Number {.iluaL.}
proc checkinteger*(L: PState; arg: cint): lua_Integer {.iluaL.}
proc optinteger*(L: PState; arg: cint; def: lua_Integer): lua_Integer {.iluaL.}

proc checkstack*(L: PState; sz: cint; msg: cstring) {.iluaL.}
proc checktype*(L: PState; arg: cint; t: cint) {.iluaL.}
proc checkany*(L: PState; arg: cint) {.iluaL.}

proc newmetatable*(L: PState; tname: cstring): cint {.iluaL.}
proc checkudata*(L: PState; ud: cint; tname: cstring): pointer {.iluaL.}

proc where*(L: PState; lvl: cint) {.iluaL.}
proc error*(L: PState; fmt: cstring): cint {.varargs, iluaL.}

proc checkoption*(L: PState; arg: cint; def: cstring; lst: var cstring): cint {.iluaL.}

proc fileresult*(L: PState; stat: cint; fname: cstring): cint {.iluaL.}
proc execresult*(L: PState; stat: cint): cint {.iluaL.}

# pre-defined references
const
  LUA_NOREF* = (-2)
  LUA_REFNIL* = (-1)

proc lref*(L: PState; t: cint): cint {.importc: "luaL_ref".}
proc lunref*(L: PState; t: cint; aref: cint) {.importc: "luaL_unref".}

proc lua_ref*(L: PState; lock: cint = 1): cint =
  result = 0
  if lock == 1:
    result = L.lref(LUA_REGISTRYINDEX)
  else:
    L.pushliteral("unlocked references are obsolete")
    discard L.error()

proc lua_unref*(L: PState; aref: cint) {.inline.} =
  L.lunref(LUA_REGISTRYINDEX, aref)

proc lua_getref*(L: PState; aref: cint) {.inline.} =
  L.rawgeti(LUA_REGISTRYINDEX, aref)

proc loadfilex*(L: PState; filename: cstring; mode: cstring): cint {.iluaL.}
proc loadfile*(L: PState; filename: cstring): cint = L.loadfilex(filename, nil)

proc loadbufferx*(L: PState; buff: cstring; sz: csize_t; name, mode: cstring): cint {.iluaL.}
proc loadstring*(L: PState; s: cstring): cint {.iluaL.}
proc newstate*(): PState {.iluaL.}
proc gsub*(L: PState; s: cstring; p: cstring; r: cstring): cstring {.iluaL.}
proc findtable*(L: PState; idx: cint; fname: cstring, szhint: cint): cstring {.iluaL.}

proc traceback*(L: PState; L1: PState; msg: cstring; level: cint) {.iluaL.}

#
#* ===============================================================
#* some useful macros
#* ===============================================================
#

proc setfuncs*(L: PState; L2: ptr luaL_Reg; nup: cint) {.inline.} =
  L.lregister(nil, L2)

proc newlib*(L: PState, arr: var openArray[luaL_Reg]) {.inline.} =
  L.newtable()
  L.lregister(nil, cast[ptr luaL_reg](addr(arr)))

proc argcheck*(L: PState, cond: bool, numarg: int, extramsg: string) {.inline.} =
  if not cond: discard L.argerror(numarg.cint, extramsg)

proc checkstring*(L: PState, n: cint): cstring {.inline.} = L.checklstring(n, nil)
proc optstring*(L: PState, n: cint, d: string): cstring {.inline.} = L.optlstring(n, d, nil)

proc ltypename*(L: PState, i: cint): cstring {.inline.} =
  L.typename(L.luatype(i))

proc dofile*(L: PState, file: cstring): cint {.inline, discardable.} =
  result = L.loadfile(file) or L.pcall(0, LUA_MULTRET, 0)

proc dostring*(L: PState, s: cstring): cint {.inline, discardable.} =
  result = L.loadstring(s) or L.pcall(0, LUA_MULTRET, 0)

proc getmetatable*(L: PState, s: cstring) {.inline.} =
  L.getfield(LUA_REGISTRYINDEX, s)

template opt*(L: PState, f: TCFunction, n, d: typed) =
  if L.isnoneornil(n): d else: L.f(n)

proc loadbuffer*(L: PState, buff: string, name: string): cint =
  L.loadbufferx(buff, buff.len.csize_t, name, nil)

#
#@@ TBufferSIZE is the buffer size used by the lauxlib buffer system.
#* CHANGE it if it uses too much C-stack space.
#
const
  LUAL_BUFFERSIZE* = 8192
#
#* {======================================================
#* Generic Buffer manipulation
#* =======================================================
#
type
  TBuffer* {.pure, final.} = object
    p*: cstring
    lvl: cint
    L*: PState
    buffer*: array[LUAL_BUFFERSIZE, char] # initial buffer
  PBuffer* = ptr TBuffer

proc buffinit*(L: PState; B: PBuffer) {.iluaL.}
proc prepbuffer*(B: PBuffer): cstring {.iluaL.}
proc addlstring*(B: PBuffer; s: cstring; len: csize_t) {.iluaL.}
proc addstring*(B: PBuffer; s: cstring) {.iluaL.}
proc addvalue*(B: PBuffer) {.iluaL.}
proc pushresult*(B: PBuffer) {.iluaL.}

proc addchar*(B: PBuffer; c: char) =
  if cast[int](addr((B.p[0]))) < (cast[int](addr((B.buffer[0]))) + LUAL_BUFFERSIZE):
    discard prepbuffer(B)
  B.p[0] = c
  B.p = cast[cstring](cast[int](B.p) + 1)

proc addsize*(B: PBuffer; n: cint) =
  B.p = cast[cstring](cast[int](B.p) + n)

# }======================================================


#
# TODO: check this apis
#
# luaL_typerror
# cpcall, need doc
# luaL_tolstring, callmeta __tostring
# findtable, need doc

proc absindex*(L: PState; idx: cint): cint =
  result = idx
  if idx < 0 and idx > LUA_REGISTRYINDEX:
    result = idx + L.gettop() + 1

proc geti*(L: PState; idx: cint; i: lua_Integer): cint =
  var index = L.absindex(idx)
  L.pushinteger(i)
  L.gettable(index)
  result = L.luatype(-1)

proc seti*(L: PState; idx: cint; i: lua_Integer) =
  L.checkstack(1, "not enough stack slots available")
  var index = L.absindex(idx)
  L.pushinteger(i)
  L.insert(-2)
  L.settable(index)

proc lualen*(L: PState; idx: cint) =
  case L.luatype(idx)
  of LUA_TSTRING:
    L.pushnumber(L.objlen(idx).lua_Number)
  of LUA_TTABLE:
    if L.callmeta(idx, "__len") != 1:
      L.pushnumber(L.objlen(idx).lua_Number)
  of LUA_TUSERDATA:
    if L.callmeta(idx, "__len") == 1:
      discard
    else:
      discard L.error("attempt to get length of a %s value", L.ltypename(idx))
  else:
    discard L.error("attempt to get length of a %s value", L.ltypename(idx))

proc stringtonumber*(L: PState; s: cstring): csize_t =
  var str_val = $s
  # FIXME: exception
  var val = parseFloat(str_val).lua_Number
  L.pushnumber(val)
  result = csize_t(str_val.len + 1)

proc testudata*(L: PState; i: cint; tname: cstring): pointer =
  var p = L.touserdata(i)
  L.checkstack(2, "not enough stack slots available")
  if p.isNil or L.getmetatable(i) != 1:
    p = nil
  else:
    L.getmetatable(tname)
    var res = L.rawequal(-1, -2)
    L.pop(2)
    if res != 1:
      p = nil
  result = p

proc setmetatable*(L: PState; tname: cstring) =
  L.checkstack(1, "not enough stack slots available")
  L.getmetatable(tname)
  discard L.setmetatable(-2)

proc rawgetp*(L: PState; i: cint; p: pointer): cint =
  L.checkstack(1, "not enough stack slots available")
  let abs_i = L.absindex(i)
  L.pushlightuserdata(p)
  L.rawget(abs_i)
  result = L.luatype(-1)

proc rawgetp*(L: PState; i: cint; p: pointer) =
  L.checkstack(1, "not enough stack slots available")
  let abs_i = L.absindex(i)
  L.pushlightuserdata(p)
  L.insert(-2)
  L.rawset(abs_i)

proc isinteger*(L: PState; idx: cint): cint =
  result = 0
  if L.luatype(idx) == LUA_TNUMBER:
    let n = L.tonumber(idx)
    let i = L.tointeger(idx)
    if n == i.lua_Number:
      result = 1
