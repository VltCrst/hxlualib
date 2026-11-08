package hxlua_lib.impl.externs;

import cpp.CastCharStar;
import cpp.ConstCharStar;
import cpp.Int64;
import cpp.RawConstPointer;
import cpp.RawPointer;
import cpp.SizeT;
import cpp.UInt32;
import cpp.UInt64;
import cpp.UInt8;
import cpp.VarList;
import cpp.VoidStarConstStar;

@:include('lua.hpp')
@:native('lua_State')
extern class Lua_State {}

@:include('lua.hpp')
@:native('lua_Number')
extern class Lua_Number {}

@:buildXml('<include name="${haxelib:hxlua_lib}/project/Build.xml" />')
@:include('lua.hpp')
extern class Lua
{
    @:native('lua_version')
    static function version(state:RawPointer<Lua_State>):RawConstPointer<Lua_Number>;

    @:native('luaL_newstate')
    static function newstate():RawPointer<Lua_State>;
}