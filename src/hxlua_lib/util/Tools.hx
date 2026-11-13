package hxlua_lib.util;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

import hxlua_lib.util.Types;

class Tools {
    public static inline function typeToString(type:LuaType):String
    {
        return switch(type)
        {
            case LUA_TNONE: "NONE";
            case LUA_TNIL: "Null";
            case LUA_TBOOLEAN: "Bool/Boolean";
            case LUA_TLIGHTUSERDATA: "LightUserData";
            case LUA_TNUMBER: "Number/Float";
            case LUA_TSTRING: "String";
            case LUA_TTABLE: "Table";
            case LUA_TFUNCTION: "Function/Method";
            case LUA_TUSERDATA: "UserData";
            case LUA_TTHREAD: "Thread";
        }
    }

    public static inline function threadToString(thrtype:ThreadStatus):String
    {
        return switch(thrtype) {
            case LUA_OK: "OK";
            case LUA_YIELD: "Yield";
            case LUA_ERRRUN: "Runtime Error!";
            case LUA_ERRSYNTAX: "Syntax Error! (during code precompilation)";
            case LUA_ERRMEM: "Memory Error! (memory shortage)";
            case LUA_ERRERR: "Critical Error!";
        }
    }
}