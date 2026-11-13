package hxlua_lib.impl.externs;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

import cpp.Char;
import cpp.ConstCharStar;
import cpp.Int64;
import cpp.RawConstPointer;
import cpp.RawPointer;
import cpp.SizeT;
import cpp.VarList;
import hxlua_lib.util.Types;

@:include('lua.hpp')
@:native('lua_State')
extern class _Lua_State {}

@:include('lua.hpp')
@:native('lua_Debug')
extern class Lua_Debug {}

@:structAccess
@:noCompletion
@:include('lua.hpp')
@:native('luaL_Buffer')
extern class LuaL_Buffer {
    var p:String;
    var lvl:Int;
    var L:Lua_State;
    var buffer:String;
}

@:buildXml('<include name="${haxelib:hxlua_lib}/project/Build.xml" />')
@:include('ext_lua.hpp')
extern class Lua
{
    // lua.h methods
    // state manipulation

    @:native('lua_upvalueindex')
    static function lua_upvalueindex(i:Int):Int;

    @:native('lua_newstate')
    static function lua_newstate(alloc:Lua_Alloc, ud:RawPointer<cpp.Void>):Lua_State;

    @:native('lua_close')
    static function lua_close(state:Lua_State):Void;

    @:native('lua_newthread')
    static function lua_newthread(state:Lua_State):Lua_State;

    @:native('lua_atpanic')
    static function lua_atpanic(state:Lua_State, panicf:Lua_CFunction):Lua_CFunction;

    // basic stack manipulation

    @:native('lua_gettop')
    static function lua_gettop(state:Lua_State):Int;

    @:native('lua_settop')
    static function lua_settop(state:Lua_State, idx:Int):Void;

    @:native('lua_pushvalue')
    static function lua_pushvalue(state:Lua_State, idx:Int):Void;

    @:native('lua_remove')
    static function lua_remove(state:Lua_State, idx:Int):Void;

    @:native('lua_insert')
    static function lua_insert(state:Lua_State, idx:Int):Void;

    @:native('lua_replace')
    static function lua_replace(state:Lua_State, idx:Int):Void;

    @:native('lua_checkstack')
    static function lua_checkstack(state:Lua_State, sz:Int):Int;

    @:native('lua_xmove')
    static function lua_xmove(stateFrom:Lua_State, stateTo:Lua_State, n:Int):Void;

    // access functions

    @:native('lua_isnumber')
    static function lua_isnumber(state:Lua_State, idx:Int):Int;

    @:native('lua_isstring')
    static function lua_isstring(state:Lua_State, idx:Int):Int;

    @:native('lua_iscfunction')
    static function lua_iscfunction(state:Lua_State, idx:Int):Int;

    @:native('lua_isuserdata')
    static function lua_isuserdata(state:Lua_State, idx:Int):Int;

    @:native('lua_type')
    static function lua_type(state:Lua_State, idx:Int):LuaType;

    @:native('lua_typename')
    static function lua_typename(state:Lua_State, tp:Int):ConstCharStar;

    @:native('lua_equal')
    static function lua_equal(state:Lua_State, idx1:Int, idx2:Int):Int;

    @:native('lua_rawequal')
    static function lua_rawequal(state:Lua_State, idx1:Int, idx2:Int):Int;

    @:native('lua_lessthan')
    static function lua_lessthan(state:Lua_State, idx1:Int, idx2:Int):Int;

    @:native('lua_tonumber')
    static function lua_tonumber(state:Lua_State, idx:Int):Lua_Number;

    @:native('lua_tointeger')
    static function lua_tointeger(state:Lua_State, idx:Int):Lua_Integer;

    @:noCompletion
    @:native('lua_toboolean')
    static function _lua_toboolean(state:Lua_State, idx:Int):Int;

    static inline function lua_toboolean(state:Lua_State, idx:Int):Bool {
        return _lua_toboolean(state, idx) != 0;
    }

    @:native('lua_tolstring')
    static function lua_tolstring(state:Lua_State, idx:Int, len:RawPointer<SizeT>):ConstCharStar;

    @:native('lua_objlen')
    static function lua_objlen(state:Lua_State, idx:Int):SizeT;

    @:native('lua_tocfunction')
    static function lua_tocfunction(state:Lua_State, idx:Int):Lua_CFunction;

    @:native('lua_touserdata')
    static function lua_touserdata(state:Lua_State, idx:Int):RawPointer<cpp.Void>;
    
    @:native('lua_tothread')
    static function lua_tothread(state:Lua_State, idx:Int):Lua_State;

    @:native('lua_topointer')
    static function lua_topointer(state:Lua_State, idx:Int):RawConstPointer<cpp.Void>;

    // push functions

    @:native('lua_pushnil')
    static function lua_pushnil(state:Lua_State):Void;

    @:native('lua_pushnumber')
    static function lua_pushnumber(state:Lua_State, n:Lua_Number):Void;

    @:native('lua_pushinteger')
    static function lua_pushinteger(state:Lua_State, n:Lua_Integer):Void;

    @:native('lua_pushlstring')
    static function lua_pushlstring(state:Lua_State, s:ConstCharStar, l:SizeT):Void;

    @:native('lua_pushstring')
    static function lua_pushstring(state:Lua_State, s:ConstCharStar):Void;

    @:native('lua_pushvfstring')
    static function lua_pushvfstring(state:Lua_State, fmt:ConstCharStar, argp:VarList):ConstCharStar;

    @:native('lua_pushfstring')
    static function lua_pushfstring(state:Lua_State, fmt:ConstCharStar, argp:VarList):ConstCharStar;

    @:native('lua_pushcclosure')
    static function lua_pushcclosure(state:Lua_State, fn:Lua_CFunction, n:Int):Void;

    @:noCompletion
    @:native('lua_pushboolean')
    static function _lua_pushboolean(state:Lua_State, idx:Int):Int;

    static inline function lua_pushboolean(state:Lua_State, idx:Int):Bool {
        return _lua_pushboolean(state, idx) != 0;
    }

    @:native('lua_pushlightuserdata')
    static function lua_pushlightuserdata(state:Lua_State, p:RawPointer<cpp.Void>):Void;

    @:native('lua_pushthread')
    static function lua_pushthread(state:Lua_State):Int;

    // get functions

    @:native('lua_gettable')
    static function lua_gettable(state:Lua_State, idx:Int):Void;

    @:native('lua_getfield')
    static function lua_getfield(state:Lua_State, idx:Int, k:ConstCharStar):Void;

    @:native('lua_rawget')
    static function lua_rawget(state:Lua_State, idx:Int):Void;

    @:native('lua_rawgeti')
    static function lua_rawgeti(state:Lua_State, idx:Int, n:Int):Void;

    @:native('lua_createtable')
    static function lua_createtable(state:Lua_State, narr:Int, nrec:Int):Void;

    @:native('lua_newuserdata')
    static function lua_newuserdata(state:Lua_State, sz:SizeT):RawPointer<cpp.Void>;

    @:native('lua_getmetatable')
    static function lua_getmetatable(state:Lua_State, objindex:Int):Int;

    @:native('lua_getfenv')
    static function lua_getfenv(state:Lua_State, idx:Int):Void;

    // set functions

    @:native('lua_settable')
    static function lua_settable(state:Lua_State, idx:Int):Void;

    @:native('lua_setfield')
    static function lua_setfield(state:Lua_State, idx:Int, k:ConstCharStar):Void;

    @:native('lua_rawset')
    static function lua_rawset(state:Lua_State, idx:Int):Void;

    @:native('lua_rawseti')
    static function lua_rawseti(state:Lua_State, idx:Int, n:Int):Void;

    @:native('lua_setmetatable')
    static function lua_setmetatable(state:Lua_State, idx:Int, n:Int):Int;

    @:native('lua_setfenv')
    static function lua_setfenv(state:Lua_State, idx:Int):Int;

    // 'load' and 'call' functions

    @:native('lua_call')
    static function lua_call(state:Lua_State, nargs:Int, nresults:Int):Void;

    @:native('lua_pcall')
    static function lua_pcall(state:Lua_State, nargs:Int, nresults:Int, errfunc:Int):Int;

    @:native('lua_cpcall')
    static function lua_cpcall(state:Lua_State, func:Lua_CFunction, ud:RawPointer<cpp.Void>):Int;

    @:native('lua_load')
    static function lua_load(state:Lua_State, reader:Lua_Reader, dt:RawPointer<cpp.Void>, chunkname:ConstCharStar):Int;

    @:native('lua_dump')
    static function lua_dump(state:Lua_State, writer:Lua_Writer, data:RawPointer<cpp.Void>):Int;

    // coroutine functions

    @:native('lua_yield')
    static function lua_yield(state:Lua_State, nresults:Int):Int;

    @:native('lua_resume')
    static function lua_resume(state:Lua_State, narg:Int):Int;

    @:native('lua_status')
    static function lua_status(state:Lua_State):Int;

    // garbage-collection function

    @:native('lua_gc')
    static function lua_gc(state:Lua_State, what:LuaGCType, data:Int):Int;

    // miscellaneous functions

    @:native('lua_error')
    static function lua_error(state:Lua_State):Int;

    @:native('lua_next')
    static function lua_next(state:Lua_State, idx:Int):Int;

    @:native('lua_concat')
    static function lua_concat(state:Lua_State, n:Int):Void;

    @:native('lua_getallocf')
    static function lua_getallocf(state:Lua_State, ud:RawPointer<RawPointer<cpp.Void>>):Lua_Alloc;

    @:native('lua_setallocf')
    static function lua_setallocf(state:Lua_State, f:Lua_Alloc, ud:RawPointer<cpp.Void>):Void;

    // hack

    @:native('lua_setlevel')
    static function lua_setlevel(stateFrom:Lua_State, stateTo:Lua_State):Void;

    // functions to be called by debugger in specific events

    @:native('ext::lua::getstack')
    static function lua_getstack(state:Lua_State, level:Int, ar:Lua_Custom_Debug):Int;

    @:native('ext::lua::getinfo')
    static function lua_getinfo(state:Lua_State, what:ConstCharStar, ar:Lua_Custom_Debug):Int;

    @:native('lua_getlocal')
    static function lua_getlocal(state:Lua_State, debugger:RawConstPointer<Lua_Debug>, n:Int):ConstCharStar;

    @:native('lua_setlocal')
    static function lua_setlocal(state:Lua_State, debugger:RawConstPointer<Lua_Debug>, n:Int):ConstCharStar;

    @:native('lua_getupvalue')
    static function lua_getupvalue(state:Lua_State, funcindex:Int, n:Int):ConstCharStar;

    @:native('lua_setupvalue')
    static function lua_setupvalue(state:Lua_State, funcindex:Int, n:Int):ConstCharStar;

    @:native('lua_sethook')
    static function lua_sethook(state:Lua_State, func:Lua_Hook, mask:Int, count:Int):Int;

    @:native('lua_gethook')
    static function lua_gethook(state:Lua_State):Lua_Hook;

    @:native('lua_gethookmask')
    static function lua_gethookmask(state:Lua_State):Int;
    
    @:native('lua_gethookcount')
    static function lua_gethookcount(state:Lua_State):Int;

    // Lua 5.2.

    @:native('lua_upvalueid')
    static function lua_upvalueid(state:Lua_State, idx:Int, n:Int):RawPointer<cpp.Void>;
    
    @:native('lua_upvaluejoin')
    static function lua_upvaluejoin(state:Lua_State, idx1:Int, n1:Int, idx2:Int, n2:Int):Void;

    @:native('lua_loadx')
    static function lua_loadx(state:Lua_State, reader:Lua_Reader, dt:RawPointer<cpp.Void>, chunkname:ConstCharStar, mode:ConstCharStar):Int;

    @:native('lua_version')
    static function lua_version(state:Lua_State):RawConstPointer<Lua_Number>;

    @:native('lua_copy')
    static function lua_copy(state:Lua_State, fromidx:Int, toidx:Int):Void;

    @:native('lua_tonumberx')
    static function lua_tonumberx(state:Lua_State, idx:Int, isnum:RawPointer<cpp.Int64>):Lua_Number;

    @:native('lua_tointegerx')
    static function lua_tointegerx(state:Lua_State, idx:Int, isnum:RawPointer<cpp.Int64>):Lua_Integer;

    // Lua 5.3.

    @:native('lua_isyieldable')
    static function lua_isyieldable(state:Lua_State):Int;

    // bonus

    @:native('lua_pop')
    static function lua_pop(state:Lua_State, n:Int):Void;

    @:native('lua_newtable')
    static function lua_newtable(state:Lua_State):Void;

    @:native('lua_register')
    static function lua_register(state:Lua_State, n:ConstCharStar, f:Lua_CFunction):Void;

    @:native('lua_pushcfunction')
    static function lua_pushcfunction(state:Lua_State, f:Lua_CFunction):Void;

    @:native('lua_strlen')
    static function lua_strlen(state:Lua_State, i:Int):SizeT;

    @:native('lua_isfunction')
    static function lua_isfunction(state:Lua_State, n:Int):Bool;

    @:native('lua_istable')
    static function lua_istable(state:Lua_State, n:Int):Bool;

    @:native('lua_islightuserdata')
    static function lua_islightuserdata(state:Lua_State, n:Int):Bool;

    @:native('lua_isnil')
    static function lua_isnil(state:Lua_State, n:Int):Bool;

    @:native('lua_isboolean')
    static function lua_isboolean(state:Lua_State, n:Int):Bool;
    
    @:native('lua_isthread')
    static function lua_isthread(state:Lua_State, n:Int):Bool;

    @:native('lua_isnone')
    static function lua_isnone(state:Lua_State, n:Int):Bool;
    
    @:native('lua_isnoneornil')
    static function lua_isnoneornil(state:Lua_State, n:Int):Bool;

    @:native('lua_pushliteral')
    static function lua_pushliteral(state:Lua_State, s:ConstCharStar):Void;

    @:native('lua_setglobal')
    static function lua_setglobal(state:Lua_State, s:ConstCharStar):Void;

    @:native('lua_getglobal')
    static function lua_getglobal(state:Lua_State, s:ConstCharStar):Void;

    @:native('lua_tostring')
    static function _lua_tostring(state:Lua_State, i:Int):ConstCharStar;

    @:native('lua_open')
    static function lua_open():Lua_State;

    @:native('lua_getregistry')
    static function lua_getregistry(state:Lua_State):Void;
    
    @:native('lua_getgccount')
    static function lua_getgccount(state:Lua_State):Int;

    @:native('ext::callbacks::setcallbacksfunction')
    static function lua_setcallbacksfunction(fun:cpp.Callable<Lua_State->String->Int>):Void;

    @:native('ext::callbacks::addcallbackfunction')
    static function lua_addcallbackfunction(state:Lua_State, name:ConstCharStar):Void;

    @:native('ext::callbacks::removecallbackfunction')
    static function lua_removecallbackfunction(state:Lua_State, name:ConstCharStar):Void;

    // lauxlib.h methods

    @:native('luaL_openlib')
    static function luaL_openlib(state:Lua_State, libname:ConstCharStar, l:RawConstPointer<LuaL_Reg>, nup:Int):Void;

    @:native('luaL_register')
    static function luaL_register(state:Lua_State, libname:ConstCharStar, l:RawConstPointer<LuaL_Reg>):Void;

    @:native('luaL_getmetafield')
    static function luaL_getmetafield(state:Lua_State, obj:Int, e:ConstCharStar):Int;

    @:native('luaL_callmeta')
    static function luaL_callmeta(state:Lua_State, obj:Int, e:ConstCharStar):Int;

    @:native('luaL_typerror')
    static function luaL_typerror(state:Lua_State, narg:Int, tname:ConstCharStar):Int;

    @:native('luaL_argerror')
    static function luaL_argerror(state:Lua_State, numarg:Int, extramsg:ConstCharStar):Int;

    @:native('luaL_checklstring')
    static function luaL_checklstring(state:Lua_State, numArg:Int, len:RawPointer<SizeT>):ConstCharStar;

    @:native('luaL_optlstring')
    static function luaL_optlstring(state:Lua_State, numArg:Int, def:ConstCharStar, len:RawPointer<SizeT>):ConstCharStar;

    @:native('luaL_checknumber')
    static function luaL_checknumber(state:Lua_State, numArg:Int):Lua_Number;

    @:native('luaL_optnumber')
    static function luaL_optnumber(state:Lua_State, nArg:Int, def:Lua_Number):Lua_Number;

    @:native('luaL_checkinteger')
    static function luaL_checkinteger(state:Lua_State, numArg:Int):Lua_Integer;

    @:native('luaL_optinteger')
    static function luaL_optinteger(state:Lua_State, nArg:Int, def:Lua_Integer):Lua_Integer;

    @:native('luaL_checkstack')
    static function luaL_checkstack(state:Lua_State, sz:Int, msg:ConstCharStar):Void;

    @:native('luaL_checktype')
    static function luaL_checktype(state:Lua_State, narg:Int, t:Int):Void;

    @:native('luaL_checkany')
    static function luaL_checkany(state:Lua_State, narg:Int):Void;

    @:native('luaL_newmetatable')
    static function luaL_newmetatable(state:Lua_State, tname:ConstCharStar):Int;

    @:native('luaL_checkudata')
    static function luaL_checkudata(state:Lua_State, ud:Int, tname:ConstCharStar):RawPointer<cpp.Void>;

    @:native('luaL_where')
    static function luaL_where(state:Lua_State, lvl:Int):Void;

    @:native('luaL_error')
    static function luaL_error(state:Lua_State, fmt:ConstCharStar, argp:VarList):Int;

    @:native('luaL_checkoption')
    static function luaL_checkoption(state:Lua_State, narg:Int, def:ConstCharStar, lst:Array<ConstCharStar>):Int;

    @:native('luaL_ref')
    static function luaL_ref(state:Lua_State, t:Int):Int;

    @:native('luaL_unref')
    static function luaL_unref(state:Lua_State, t:Int, ref:Int):Void;

    @:native('luaL_loadfile')
    static function luaL_loadfile(state:Lua_State, filename:ConstCharStar):Int;

    @:native('luaL_loadbuffer')
    static function luaL_loadbuffer(state:Lua_State, buff:ConstCharStar, sz:SizeT, name:ConstCharStar):Int;

    @:native('luaL_loadstring')
    static function luaL_loadstring(state:Lua_State, s:ConstCharStar):Int;

    @:native('luaL_newstate')
    static function luaL_newstate():Lua_State;

    @:native('luaL_gsub')
    static function luaL_gsub(state:Lua_State, s:ConstCharStar, p:ConstCharStar, r:ConstCharStar):ConstCharStar;

    @:native('luaL_findtable')
    static function luaL_findtable(state:Lua_State, idx:Int, fname:ConstCharStar, szhint:Int):ConstCharStar;

    @:native('luaL_fileresult')
    static function luaL_fileresult(state:Lua_State, stat:Int, fname:ConstCharStar):Int;

    @:native('luaL_execresult')
    static function luaL_execresult(state:Lua_State, stat:Int):Int;

    @:native('luaL_loadfilex')
    static function luaL_loadfilex(state:Lua_State, filename:ConstCharStar, mode:ConstCharStar):Int;

    @:native('luaL_loadbufferx')
    static function luaL_loadbufferx(state:Lua_State, buff:ConstCharStar, sz:SizeT, name:ConstCharStar, mode:ConstCharStar):Int;

    @:native('luaL_traceback')
    static function luaL_trackback(state:Lua_State, state1:Lua_State, msg:ConstCharStar, level:Int):Void;

    @:native('luaL_setfuncs')
    static function luaL_setfuncs(state:Lua_State, l:RawConstPointer<LuaL_Reg>, nup:Int):Void;

    @:native('luaL_pushmodule')
    static function luaL_pushmodule(state:Lua_State, modname:ConstCharStar, sizehint:Int):Void;

    @:native('luaL_testudata')
    static function luaL_testudata(state:Lua_State, ud:Int, tname:ConstCharStar):RawPointer<cpp.Void>;

    @:native('luaL_setmetatable')
    static function luaL_setmetatable(state:Lua_State, tanem:ConstCharStar):Void;

    @:native('luaL_argcheck')
    static function luaL_argcheck(state:Lua_State, cond:Bool, numarg:Int, extramsg:ConstCharStar):Int;

    @:native('luaL_checkstring')
    static function luaL_checkstring(state:Lua_State, n:Int):ConstCharStar;

    @:native('luaL_optstring')
    static function luaL_optstring(state:Lua_State, n:Int, d:ConstCharStar):ConstCharStar;

    @:native('luaL_checkint')
    static function luaL_checkint(state:Lua_State, n:Int):Int;

    @:native('luaL_optint')
    static function luaL_optint(state:Lua_State, n:Int, d:Lua_Integer):Int;

    @:native('luaL_checklong')
    static function luaL_checklong(state:Lua_State, n:Int):cpp.Int64;

    @:native('luaL_optlong')
    static function luaL_optlong(state:Lua_State, n:Int, d:Lua_Integer):cpp.Int64;

    @:native('luaL_typename')
    static function luaL_typename(state:Lua_State, idx:Int):ConstCharStar;

    @:native('luaL_dofile')
    static function luaL_dofile(state:Lua_State, fn:ConstCharStar):Int;

    @:native('luaL_dostring')
    static function luaL_dostring(state:Lua_State, s:ConstCharStar):Int;

    @:native('luaL_getmetatable')
    static function luaL_getmetatable(state:Lua_State, n:ConstCharStar):Void;

    @:native('luaL_opt')
    static function luaL_opt(state:Lua_State, f:cpp.Callable<(state:Lua_State, n:Int) -> Dynamic>, n:Int, d:Dynamic):Int;

    @:native('luaL_newlibtable')
    static function luaL_newlibtable(state:Lua_State, l:RawConstPointer<LuaL_Reg>):Void;

    @:native('luaL_newlib')
    static function luaL_newlib(state:Lua_State, l:RawConstPointer<LuaL_Reg>):Void;

    @:native('luaL_addchar')
    static function luaL_addchar(B:RawPointer<LuaL_Buffer>, c:String):Void;

    @:native('luaL_putchar')
    static function luaL_putchar(B:RawPointer<LuaL_Buffer>, c:String):Void;

    @:native('luaL_addsize')
    static function luaL_addsize(B:RawPointer<LuaL_Buffer>, n:Int):Void;

    @:native('luaL_buffinit')
    static function luaL_buffinit(state:Lua_State, B:RawPointer<LuaL_Buffer>):Void;

    @:native('luaL_prepbuffer')
    static function luaL_prepbuffer(B:RawPointer<LuaL_Buffer>):RawPointer<Char>;
    
    @:native('luaL_addlstring')
    static function luaL_addlstring(B:RawPointer<LuaL_Buffer>, s:ConstCharStar, l:SizeT):Void;

    @:native('luaL_addstring')
    static function luaL_addstring(B:RawPointer<LuaL_Buffer>, s:ConstCharStar):Void;

    @:native('luaL_addvalue')
    static function luaL_addvalue(B:RawPointer<LuaL_Buffer>):Void;

    @:native('luaL_pushresult')
    static function luaL_pushresult(B:RawPointer<LuaL_Buffer>):Void;

    // luajit.h

    @:native('luaJIT_setmode')
    static function luaJIT_setmode(state:Lua_State, idx:Int, mode:LuaJITModes):Int;

    @:native('luaJIT_profile_start')
    static function luaJIT_profile_start(state:Lua_State, mode:ConstCharStar, cb:LuaJIT_Profile_Callback, data:RawPointer<cpp.Void>):Void;

    @:native('luaJIT_profile_stop')
    static function luaJIT_profile_stop(state:Lua_State):Void;

    @:native('luaJIT_profile_dumpstack')
    static function luaJIT_profile_dumpstack(state:Lua_State, fmt:ConstCharStar, depth:Int, len:RawPointer<SizeT>):ConstCharStar;

    // lualib.h

    @:native('luaopen_base')
    static function luaopen_base(state:Lua_State):Int;

    @:native('luaopen_math')
    static function luaopen_math(state:Lua_State):Int;

    @:native('luaopen_string')
    static function luaopen_string(state:Lua_State):Int;

    @:native('luaopen_table')
    static function luaopen_table(state:Lua_State):Int;

    @:native('luaopen_io')
    static function luaopen_io(state:Lua_State):Int;

    @:native('luaopen_os')
    static function luaopen_os(state:Lua_State):Int;

    @:native('luaopen_package')
    static function luaopen_package(state:Lua_State):Int;

    @:native('luaopen_debug')
    static function luaopen_debug(state:Lua_State):Int;

    @:native('luaopen_bit')
    static function luaopen_jit(state:Lua_State):Int;

    @:native('luaopen_ffi')
    static function luaopen_ffi(state:Lua_State):Int;

    @:native('luaopen_string_buffer')
    static function luaopen_string_buffer(state:Lua_State):Int;

    @:native('luaL_openlibs')
    static function luaL_openlibs(state:Lua_State):Void;

    // helpers

    /*
    @:functionCode('
        return ::String(LUA_VERSION);
    ')
    static function version():String;

    @:functionCode('
        return ::String(LUA_RELEASE);
    ')
    static function versionRelease():String;

    @:functionCode('
        return (int)LUA_VERSION_NUM;
    ')
    static function versionNum():Int;

    @:functionCode('
        return ::String(LUA_COPYRIGHT);
    ')
    static function copyright():String;

    @:functionCode('
        return ::String(LUA_AUTHORS);
    ')
    static function authors():String;

    @:functionCode('
        return ::String(LUAJIT_VERSION);
    ')
    static function jit_version():String;

    @:functionCode('
        return (int)LUAJIT_VERSION_NUM;
    ')
    static function jit_versionNum():Int;

    @:functionCode('
        return LUAJIT_VERSION_SYM;
    ')
    static function jit_versionSYM():Void;

    @:functionCode('
        return ::String(LUAJIT_COPYRIGHT);
    ')
    static function jit_copyright():String;

    @:native('LUAJIT_URL')
    static function jit_url():String;
    */

    @:native('ext::hxtrace::registerhxtracelib')
    static function lua_registerhxtracelib(state:Lua_State):Void;

    @:native('ext::hxtrace::registerhxtracefunc')
    static function lua_registerhxtracefunc(f:cpp.Callable<String->Int>):Void;
}

@:include('lua.hpp')
@:native('::cpp::Reference<lua_State>')
extern class Lua_State {}

typedef LuaJIT_Profile_Callback = cpp.Callable<(data:RawPointer<cpp.Void>, state:Lua_State, samples:Int, vmstate:Int) -> Void>;
typedef Lua_CFunction = cpp.Callable<(state:Lua_State) -> Int>;
typedef Lua_Reader = cpp.Callable<(state:Lua_State, ud:RawPointer<cpp.Void>, sz:RawPointer<SizeT>) -> ConstCharStar>;
typedef Lua_Writer = cpp.Callable<(state:Lua_State, p:RawConstPointer<cpp.Void>, sz:SizeT, ud:RawPointer<cpp.Void>) -> Int>;
typedef Lua_Alloc = cpp.Callable<(ud:RawPointer<cpp.Void>, ptr:RawPointer<cpp.Void>, osize:SizeT, nsize:SizeT) -> Void>;
typedef Lua_Hook = cpp.Callable<(state:Lua_State, debugger:RawPointer<Lua_Debug>) -> Void>;
typedef Lua_Number = cpp.Float64;
typedef Lua_UACNumber = cpp.Float64;
typedef Lua_Integer = cpp.Int64;
typedef Lua_Chunkreader = Lua_Reader;
typedef Lua_Chunkwriter = Lua_Writer;
typedef LuaL_Reg = {
    var name:ConstCharStar;
    var func:Lua_CFunction;
}
typedef Lua_Custom_Debug = {
    ?event:Int, ?name:String, ?namewhat:String, ?what:String, ?source:String, ?currentline:Int, ?nups:Int, ?linedefined:Int, ?lastlinedefined:Int, ?short_arc:Array<String>, ?i_ci:Int
}