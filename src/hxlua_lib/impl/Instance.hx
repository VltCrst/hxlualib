package hxlua_lib.impl;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

import cpp.Pointer;
import hxlua_lib.util.Types;
import cpp.CastCharStar;
import cpp.ConstCharStar;
import cpp.Function;
import cpp.RawConstPointer;
import cpp.RawPointer;
import cpp.StdVector;
import cpp.Stdlib;
import cpp.UInt32;
import cpp.VarList;

import haxe.PosInfos;
import haxe.extern.AsVar;
import haxe.io.Path;

import hxlua_lib.impl.externs.Lua;

@:cppInclude('stdarg.h')
class Instance {
    @:noCompletion
    public var state:Null<RawPointer<Lua_State>>;

    public function new():Void
    {
        state = Lua.lua_open();
    }
}