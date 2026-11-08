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

@:include('lua.h')
@:native('lua_State')
extern class Lua_State {}

@:buildXml('<include name="${haxelib:hxlua_lib}/project/Build.xml" />')
@:include('lua_base.h')
extern class Lua
{
    @:native('luabase_version')
    static function version():ConstCharStar;
}