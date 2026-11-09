package hxlua_lib.impl;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

import cpp.SizeT;
import cpp.ConstCharStar;
import cpp.RawPointer;
import hxlua_lib.impl.externs.Lua;
import hxlua_lib.util.Types;

class LuaG {
    public static inline function lua_upvalueindex(i:Int):Int
        return (LuaIndex.LUA_GLOBALSINDEX - i);
}

