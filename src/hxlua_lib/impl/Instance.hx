package src.hxlua_lib.impl;

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

class Instance {
    @:noCompletion
    public var nativeInstance:Null<RawPointer<Lua_State>>;

    public function new():Void
    {
        trace(Lua.version());
        //nativeInstance = Lua.createstate();
    }
}