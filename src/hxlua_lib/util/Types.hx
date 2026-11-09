package hxlua_lib.util;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

enum abstract Types(Int) from Int to Int
{
    var LUA_MINSTACK = 20;
}

enum abstract LuaGCType(Int) from Int to Int
{
    var LUA_GCSTOP = 0;
    var LUA_GCRESTART = 1;
    var LUA_GCCOLLECT = 2;
    var LUA_GCCOUNT = 3;
    var LUA_GCCOUNTB = 4;
    var LUA_GCSTEP = 5;
    var LUA_GCSETPAUSE = 6;
    var LUA_GCSETSTEPMUL = 7;
    var LUA_GCISRUNNING = 9;
}

enum abstract LuaHookCodes(Int) from Int to Int
{
    var LUA_HOOKCALL = 0;
    var LUA_HOOKRET = 1;
    var LUA_HOOKLINE = 2;
    var LUA_HOOKCOUNT = 3;
    var LUA_HOOKTAILRET = 4;
}

enum abstract LuaMask(Int) from Int to Int
{
    var LUA_MASKCALL = (1 << LuaHookCodes.LUA_HOOKCALL);
    var LUA_MASKRET = (1 << LuaHookCodes.LUA_HOOKRET);
    var LUA_MASKLINE = (1 << LuaHookCodes.LUA_HOOKLINE);
    var LUA_MASKCOUNT = (1 << LuaHookCodes.LUA_HOOKCOUNT);
}

enum abstract LuaIndex(Int) from Int to Int
{
    var LUA_REGISTRYINDEX = -10000;
    var LUA_ENVIRONINDEX = -10001;
    var LUA_GLOBALSINDEX = -10002;
}

enum abstract LuaType(Int) from Int to Int
{
    var LUA_TNONE = -1;
    var LUA_TNIL = 0;
    var LUA_TBOOLEAN = 1;
    var LUA_TLIGHTUSERDATA = 2;
    var LUA_TNUMBER = 3;
    var LUA_TSTRING = 4;
    var LUA_TTABLE = 5;
    var LUA_TFUNCTION = 6;
    var LUA_TUSERDATA = 7;
    var LUA_TTHREAD = 8;
}

enum abstract ThreadStatus(Int) from Int to Int
{
    var LUA_OK = 0;
    var LUA_YIELD = 1;
    var LUA_ERRRUN = 2;
    var LUA_ERRSYNTAX = 3;
    var LUA_ERRMEM = 4;
    var LUA_ERRERR = 5;
}