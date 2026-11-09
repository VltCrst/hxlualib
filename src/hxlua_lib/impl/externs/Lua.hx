package hxlua_lib.impl.externs;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

import cpp.Char;
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
import hxlua_lib.util.Types;

@:include('lua.hpp')
@:native('lua_State')
extern class Lua_State {}

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
    var L:RawPointer<Lua_State>;
    var buffer:String;
}

@:buildXml('<include name="${haxelib:hxlua_lib}/project/Build.xml" />')
@:include('lua.hpp')
@:headerCode('
    typedef ::cpp::Function < int(::cpp::Reference<lua_State>, ::String) > luaCallbackFun;
    typedef ::cpp::Function < int(String) > HxTraceFun;

    static luaCallbackFun event_fun = 0;
    static int luaCallback(lua_State *L) {
        return event_fun(L, ::String(lua_tostring(L, lua_upvalueindex(1))));
    }

    static int onError(lua_State *L) {
        const char *msg = lua_tostring(L, 1);

        if (msg) {
            luaL_traceback(L, L, msg, 1);    
        }
        else if (!lua_isnoneornil(L, 1)) {
            if (!luaL_callmeta(L, 1, "__tostring"))
            {
                lua_pushliteral(L, "(No Error Message)");        
            }
        }
        
        return 1;
    }

    int setErrorHandler(lua_State *L) {
        lua_pushcfunction(L, onError);
        return 1;
    }

    static HxTraceFun print_fun = 0;
    static int hx_trace(lua_State *L) {
        std::stringstream buffer;
        int n = lua_gettop(L);

        lua_getglobal(L, "tostring");

        for ( int i = 1; i <= n; ++i ) {
            const char* s = NULL;
            size_t l = 0;
            
            lua_pushvalue(L, -1);
            lua_pushvalue(L, i);
            lua_call(L, 1, 1);

            s = lua_tolstring(L, -1, &l);
            if ( s == NULL ) {
                return luaL_error(L, LUA_QL("tostring") " must return a string to " LUA_QL("print"));    
            }

            if ( i>1 ) {
                buffer << "\t";    
            }

            buffer << s;

            lua_pop(L, 1);
        }
        
        print_fun(::String(buffer.str().c_str()));
        return 0;
    }

    static const struct luaL_Reg printlib [] = {
        {"print", hx_trace},
        {NULL, NULL}
    };
')
extern class Lua
{
    // lua.h methods
    // state manipulation

    @:native('lua_newstate')
    static function lua_newstate(alloc:Lua_Alloc, ud:RawPointer<cpp.Void>):RawPointer<Lua_State>;

    @:native('lua_close')
    static function lua_close(state:RawPointer<Lua_State>):Void;

    @:native('lua_newthread')
    static function lua_newthread(state:RawPointer<Lua_State>):RawPointer<Lua_State>;

    @:native('lua_atpanic')
    static function lua_atpanic(state:RawPointer<Lua_State>, panicf:Lua_CFunction):Lua_CFunction;

    // basic stack manipulation

    @:native('lua_gettop')
    static function lua_gettop(state:RawPointer<Lua_State>):Int;

    @:native('lua_settop')
    static function lua_settop(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_pushvalue')
    static function lua_pushvalue(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_remove')
    static function lua_remove(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_insert')
    static function lua_insert(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_replace')
    static function lua_replace(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_checkstack')
    static function lua_checkstack(state:RawPointer<Lua_State>, sz:Int):Int;

    @:native('lua_xmove')
    static function lua_xmove(stateFrom:RawPointer<Lua_State>, stateTo:RawPointer<Lua_State>, n:Int):Void;

    // access functions

    @:native('lua_isnumber')
    static function lua_isnumber(state:RawPointer<Lua_State>, idx:Int):Int;

    @:native('lua_isstring')
    static function lua_isstring(state:RawPointer<Lua_State>, idx:Int):Int;

    @:native('lua_iscfunction')
    static function lua_iscfunction(state:RawPointer<Lua_State>, idx:Int):Int;

    @:native('lua_isuserdata')
    static function lua_isuserdata(state:RawPointer<Lua_State>, idx:Int):Int;

    @:native('lua_type')
    static function lua_type(state:RawPointer<Lua_State>, idx:Int):LuaType;

    @:functionCode('
        return ::String(lua_typename(state, tp));
    ')
    static function lua_typename(state:RawPointer<Lua_State>, tp:Int):String;

    @:native('lua_equal')
    static function lua_equal(state:RawPointer<Lua_State>, idx1:Int, idx2:Int):Int;

    @:native('lua_rawequal')
    static function lua_rawequal(state:RawPointer<Lua_State>, idx1:Int, idx2:Int):Int;

    @:native('lua_lessthan')
    static function lua_lessthan(state:RawPointer<Lua_State>, idx1:Int, idx2:Int):Int;

    @:native('lua_tonumber')
    static function lua_tonumber(state:RawPointer<Lua_State>, idx:Int):Lua_Number;

    @:native('lua_tointeger')
    static function lua_tointeger(state:RawPointer<Lua_State>, idx:Int):Lua_Integer;

    @:noCompletion
    @:native('lua_toboolean')
    static function _lua_toboolean(state:RawPointer<Lua_State>, idx:Int):Int;

    static inline function lua_toboolean(state:RawPointer<Lua_State>, idx:Int):Bool {
        return _lua_toboolean(state, idx) != 0;
    }

    @:functionCode('
        return ::String(lua_tolstring(state, idx, len));
    ')
    static function lua_tolstring(state:RawPointer<Lua_State>, idx:Int, len:Null<RawPointer<SizeT>>):String;

    @:native('lua_objlen')
    static function lua_objlen(state:RawPointer<Lua_State>, idx:Int):SizeT;

    @:native('lua_tocfunction')
    static function lua_tocfunction(state:RawPointer<Lua_State>, idx:Int):Lua_CFunction;

    @:native('lua_touserdata')
    static function lua_touserdata(state:RawPointer<Lua_State>, idx:Int):RawPointer<cpp.Void>;
    
    @:native('lua_tothread')
    static function lua_tothread(state:RawPointer<Lua_State>, idx:Int):RawPointer<Lua_State>;

    @:native('lua_topointer')
    static function lua_topointer(state:RawPointer<Lua_State>, idx:Int):RawConstPointer<cpp.Void>;

    // push functions

    @:native('lua_pushnil')
    static function lua_pushnil(state:RawPointer<Lua_State>):Void;

    @:native('lua_pushnumber')
    static function lua_pushnumber(state:RawPointer<Lua_State>, n:Lua_Number):Void;

    @:native('lua_pushinteger')
    static function lua_pushinteger(state:RawPointer<Lua_State>, n:Lua_Integer):Void;

    @:native('lua_pushlstring')
    static function lua_pushlstring(state:RawPointer<Lua_State>, s:ConstCharStar, l:SizeT):Void;

    @:native('lua_pushstring')
    static function lua_pushstring(state:RawPointer<Lua_State>, s:ConstCharStar):Void;

    @:native('lua_pushvfstring')
    static function lua_pushvfstring(state:RawPointer<Lua_State>, fmt:ConstCharStar, argp:VarList):ConstCharStar;

    @:native('lua_pushfstring')
    static function lua_pushfstring(state:RawPointer<Lua_State>, fmt:ConstCharStar, argp:VarList):ConstCharStar;

    @:native('lua_pushcclosure')
    static function lua_pushcclosure(state:RawPointer<Lua_State>, fn:Lua_CFunction, n:Int):Void;

    @:native('lua_pushboolean')
    static function lua_pushboolean(state:RawPointer<Lua_State>, b:Int):Void;

    @:native('lua_pushlightuserdata')
    static function lua_pushlightuserdata(state:RawPointer<Lua_State>, p:RawPointer<cpp.Void>):Void;

    @:native('lua_pushthread')
    static function lua_pushthread(state:RawPointer<Lua_State>):Int;

    // get functions

    @:native('lua_gettable')
    static function lua_gettable(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_getfield')
    static function lua_getfield(state:RawPointer<Lua_State>, idx:Int, k:ConstCharStar):Void;

    @:native('lua_rawget')
    static function lua_rawget(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_rawgeti')
    static function lua_rawgeti(state:RawPointer<Lua_State>, idx:Int, n:Int):Void;

    @:native('lua_createtable')
    static function lua_createtable(state:RawPointer<Lua_State>, narr:Int, nrec:Int):Void;

    @:native('lua_newuserdata')
    static function lua_newuserdata(state:RawPointer<Lua_State>, sz:SizeT):RawPointer<cpp.Void>;

    @:native('lua_getmetatable')
    static function lua_getmetatable(state:RawPointer<Lua_State>, objindex:Int):Int;

    @:native('lua_getfenv')
    static function lua_getfenv(state:RawPointer<Lua_State>, idx:Int):Void;

    // set functions

    @:native('lua_settable')
    static function lua_settable(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_setfield')
    static function lua_setfield(state:RawPointer<Lua_State>, idx:Int, k:ConstCharStar):Void;

    @:native('lua_rawset')
    static function lua_rawset(state:RawPointer<Lua_State>, idx:Int):Void;

    @:native('lua_rawseti')
    static function lua_rawseti(state:RawPointer<Lua_State>, idx:Int, n:Int):Void;

    @:native('lua_setmetatable')
    static function lua_setmetatable(state:RawPointer<Lua_State>, idx:Int, n:Int):Int;

    @:native('lua_setfenv')
    static function lua_setfenv(state:RawPointer<Lua_State>, idx:Int):Int;

    // 'load' and 'call' functions

    @:native('lua_call')
    static function lua_call(state:RawPointer<Lua_State>, nargs:Int, nresults:Int):Void;

    @:native('lua_pcall')
    static function lua_pcall(state:RawPointer<Lua_State>, nargs:Int, nresults:Int, errfunc:Int):Int;

    @:native('lua_cpcall')
    static function lua_cpcall(state:RawPointer<Lua_State>, func:Lua_CFunction, ud:RawPointer<cpp.Void>):Int;

    @:native('lua_load')
    static function lua_load(state:RawPointer<Lua_State>, reader:Lua_Reader, dt:RawPointer<cpp.Void>, chunkname:ConstCharStar):Int;

    @:native('lua_dump')
    static function lua_dump(state:RawPointer<Lua_State>, writer:Lua_Writer, data:RawPointer<cpp.Void>):Int;

    // coroutine functions

    @:native('lua_yield')
    static function lua_yield(state:RawPointer<Lua_State>, nresults:Int):Int;

    @:native('lua_resume')
    static function lua_resume(state:RawPointer<Lua_State>, narg:Int):Int;

    @:native('lua_status')
    static function lua_status(state:RawPointer<Lua_State>):Int;

    // garbage-collection function

    @:native('lua_gc')
    static function lua_gc(state:RawPointer<Lua_State>, what:LuaGCType, data:Int):Int;

    // miscellaneous functions

    @:native('lua_error')
    static function lua_error(state:RawPointer<Lua_State>):Int;

    @:native('lua_next')
    static function lua_next(state:RawPointer<Lua_State>, idx:Int):Int;

    @:native('lua_concat')
    static function lua_concat(state:RawPointer<Lua_State>, n:Int):Void;

    @:native('lua_getallocf')
    static function lua_getallocf(state:RawPointer<Lua_State>, ud:RawPointer<RawPointer<cpp.Void>>):Lua_Alloc;

    @:native('lua_setallocf')
    static function lua_setallocf(state:RawPointer<Lua_State>, f:Lua_Alloc, ud:RawPointer<cpp.Void>):Void;

    // hack

    @:native('lua_setlevel')
    static function lua_setlevel(stateFrom:RawPointer<Lua_State>, stateTo:RawPointer<Lua_State>):Void;

    // functions to be called by debugger in specific events

    @:functionCode('
        lua_Debug dbg;
        int ret = lua_getstack(state, level, &dbg);
        ar->__FieldRef(HX_CSTRING("i_ci")) = (int)dbg.i_ci;
        return ret;
    ')
    static function lua_getstack(state:RawPointer<Lua_State>, level:Int, ar:Lua_Custom_Debug):Int;

    @:functionCode('
        lua_Debug dbg;
        dbg.i_ci = ar->__FieldRef(HX_CSTRING("i_ci"));

        int ret = lua_getinfo(state, what, &dbg);
        if (strchr(what, "S")) {
            if (dbg.source != NULL) {
                ar->__FieldRef(HX_CSTRING("source")) = ::String(dbg.source);    
            }

            if (dbg.short_src != NULL) {
                ar->__FieldRef(HX_CSTRING("short_src")) = ::String(dbg.short_src);    
            }
            
            if (dbg.linedefined != NULL) {
                ar->__FieldRef(HX_CSTRING("linedefined")) = (int)dbg.linedefined;    
            }
            
            if (dbg.lastlinedefined != NULL) {
                ar->__FieldRef(HX_CSTRING("lastlinedefined")) = (int)dbg.lastlinedefined;    
            }

            if (dbg.what != NULL) {
                ar->__FieldRef(HX_CSTRING("what")) = ::String(dbg.what);    
            }
        }

        if (strchr(what, "n")) {
            if (dbg.name != NULL) {
                ar->__FieldRef(HX_CSTRING("name")) = ::String(dbg.name);    
            }

            if (dbg.namewhat != NULL) {
                ar->__FieldRef(HX_CSTRING("namewhat")) = ::String(dbg.namewhat);    
            }
        }

        if (strchr(what, "l")) {
            if (dbg.currentline != NULL) {
                ar->__FieldRef(HX_CSTRING("currentline")) = (int)dbg.currentline;    
            }
        }

        if (strchr(what, "u")) {
            if (dbg.nups != NULL) {
                ar->__FieldRef(HX_CSTRING("nups")) = (int)dbg.nups;    
            }
        }

        return ret;
    ')
    static function lua_getinfo(state:RawPointer<Lua_State>, what:ConstCharStar, ar:Lua_Custom_Debug):Int;

    @:native('lua_getlocal')
    static function lua_getlocal(state:RawPointer<Lua_State>, debugger:RawConstPointer<Lua_Debug>, n:Int):ConstCharStar;

    @:native('lua_setlocal')
    static function lua_setlocal(state:RawPointer<Lua_State>, debugger:RawConstPointer<Lua_Debug>, n:Int):ConstCharStar;

    @:native('lua_getupvalue')
    static function lua_getupvalue(state:RawPointer<Lua_State>, funcindex:Int, n:Int):ConstCharStar;

    @:native('lua_setupvalue')
    static function lua_setupvalue(state:RawPointer<Lua_State>, funcindex:Int, n:Int):ConstCharStar;

    @:native('lua_sethook')
    static function lua_sethook(state:RawPointer<Lua_State>, func:Lua_Hook, mask:Int, count:Int):Int;

    @:native('lua_gethook')
    static function lua_gethook(state:RawPointer<Lua_State>):Lua_Hook;

    @:native('lua_gethookmask')
    static function lua_gethookmask(state:RawPointer<Lua_State>):Int;
    
    @:native('lua_gethookcount')
    static function lua_gethookcount(state:RawPointer<Lua_State>):Int;

    // Lua 5.2.

    @:native('lua_upvalueid')
    static function lua_upvalueid(state:RawPointer<Lua_State>, idx:Int, n:Int):RawPointer<cpp.Void>;
    
    @:native('lua_upvaluejoin')
    static function lua_upvaluejoin(state:RawPointer<Lua_State>, idx1:Int, n1:Int, idx2:Int, n2:Int):Void;

    @:native('lua_loadx')
    static function lua_loadx(state:RawPointer<Lua_State>, reader:Lua_Reader, dt:RawPointer<cpp.Void>, chunkname:ConstCharStar, mode:ConstCharStar):Int;

    //@:native('lua_version')
    //static function lua_version(state:RawPointer<Lua_State>):cpp.Float32;

    @:native('lua_copy')
    static function lua_copy(state:RawPointer<Lua_State>, fromidx:Int, toidx:Int):Void;

    @:native('lua_tonumberx')
    static function lua_tonumberx(state:RawPointer<Lua_State>, idx:Int, isnum:RawPointer<cpp.Int64>):Lua_Number;

    @:native('lua_tointegerx')
    static function lua_tointegerx(state:RawPointer<Lua_State>, idx:Int, isnum:RawPointer<cpp.Int64>):Lua_Integer;

    // Lua 5.3.

    @:native('lua_isyieldable')
    static function lua_isyieldable(state:RawPointer<Lua_State>):Int;

    // bonus

    @:native('lua_pop')
    static function lua_pop(state:RawPointer<Lua_State>, n:Int):Void;

    @:native('lua_newtable')
    static function lua_newtable(state:RawPointer<Lua_State>):Void;

    @:native('lua_register')
    static function lua_register(state:RawPointer<Lua_State>, n:ConstCharStar, f:Lua_CFunction):Void;

    @:native('lua_pushcfunction')
    static function lua_pushcfunction(state:RawPointer<Lua_State>, f:Lua_CFunction):Void;

    @:native('lua_strlen')
    static function lua_strlen(state:RawPointer<Lua_State>, i:Int):SizeT;

    @:native('lua_isfunction')
    static function lua_isfunction(state:RawPointer<Lua_State>, n:Int):Bool;

    @:native('lua_istable')
    static function lua_istable(state:RawPointer<Lua_State>, n:Int):Bool;

    @:native('lua_islightuserdata')
    static function lua_islightuserdata(state:RawPointer<Lua_State>, n:Int):Bool;

    @:native('lua_isnil')
    static function lua_isnil(state:RawPointer<Lua_State>, n:Int):Bool;

    @:native('lua_isboolean')
    static function lua_isboolean(state:RawPointer<Lua_State>, n:Int):Bool;
    
    @:native('lua_isthread')
    static function lua_isthread(state:RawPointer<Lua_State>, n:Int):Bool;

    @:native('lua_isnone')
    static function lua_isnone(state:RawPointer<Lua_State>, n:Int):Bool;
    
    @:native('lua_isnoneornil')
    static function lua_isnoneornil(state:RawPointer<Lua_State>, n:Int):Bool;

    @:native('lua_pushliteral')
    static function lua_pushliteral(state:RawPointer<Lua_State>, s:ConstCharStar):Void;

    @:native('lua_setglobal')
    static function lua_setglobal(state:RawPointer<Lua_State>, s:ConstCharStar):Void;

    @:native('lua_getglobal')
    static function lua_getglobal(state:RawPointer<Lua_State>, s:ConstCharStar):Void;

    @:functionCode('
        return ::String(lua_tostring(state, i));
    ')
    static function lua_tostring(state:RawPointer<Lua_State>, i:Int):String;

    @:native('lua_open')
    static function lua_open():RawPointer<Lua_State>;

    @:native('lua_getregistry')
    static function lua_getregistry(state:RawPointer<Lua_State>):Void;
    
    @:native('lua_getgccount')
    static function lua_getgccount(state:RawPointer<Lua_State>):Int;

    @:functionCode('event_fun = fun')
    static function lua_set_callbacks_function(fun:cpp.Callable<RawPointer<Lua_State>->String->Int>):Void;

    @:functionCode('
        lua_pushstring(state, name);
        lua_pushcclosure(state, luaCallback, 1);
        lua_setglobal(state, name);
    ')
    static function lua_add_callback_function(state:RawPointer<Lua_State>, name:ConstCharStar):Void;

    @:functionCode('
        lua_pushnil(state);
        lua_setglobal(state, name);
    ')
    static function lua_remove_callback_function(state:RawPointer<Lua_State>, name:ConstCharStar):Void;

    // lauxlib.h methods

    @:functionCode('
        return ::String(luaL_checklstring(l, numArg, len));
    ')
    static function luaL_checklstring(state:RawPointer<Lua_State>, numArg:Int, len:RawPointer<SizeT>):String;

    @:functionCode('
        return ::String(luaL_optlstring(state, numArg, def, len));
    ')
    static function luaL_optlstring(state:RawPointer<Lua_State>, numArg:Int, def:ConstCharStar, len:RawPointer<SizeT>):String;

    @:functionCode('
        return ::String(luaL_prepbuffer(B));
    ')
    static function luaL_prepbuffer(B:RawPointer<LuaL_Buffer>):String;

    @:functionCode('
        return ::String(luaL_gsub(state, s, p, r));
    ')
    static function luaL_gsub(state:RawPointer<Lua_State>, s:ConstCharStar, p:ConstCharStar, r:ConstCharStar):String;

    @:functionCode('
        return ::String(luaL_findtable(state, idx, fname, szhint));
    ')
    static function luaL_findtable(state:RawPointer<Lua_State>, idx:Int, fname:ConstCharStar, szhint:Int):String;

    @:functionCode('
        return ::String(luaL_checkstring(state, n));
    ')
    static function luaL_checkstring(state:RawPointer<Lua_State>, n:Int):String;

    @:functionCode('
        return ::String(luaL_optstring(state, n, d));
    ')
    static function luaL_optstring(state:RawPointer<Lua_State>, n:Int, d:ConstCharStar):String;

    @:functionCode('
        return ::String(luaL_typename(state, idx));
    ')
    static function luaL_typename(state:RawPointer<Lua_State>, idx:Int):String;

    @:native('luaL_openlib')
    static function luaL_openlib(state:RawPointer<Lua_State>, libname:ConstCharStar, l:RawConstPointer<LuaL_Reg>, nup:Int):Void;

    @:native('luaL_register')
    static function luaL_register(state:RawPointer<Lua_State>, libname:ConstCharStar, l:RawConstPointer<LuaL_Reg>):Void;

    @:native('luaL_getmetafield')
    static function luaL_getmetafield(state:RawPointer<Lua_State>, obj:Int, e:ConstCharStar):Int;

    @:native('luaL_callmeta')
    static function luaL_callmeta(state:RawPointer<Lua_State>, obj:Int, e:ConstCharStar):Int;

    @:native('luaL_newstate')
    static function luaL_newstate():RawPointer<Lua_State>;

    @:native('luaL_dofile')
    static function luaL_dofile(state:RawPointer<Lua_State>, filename:String):Int;

    @:native('luaL_openlibs')
    static function luaL_openlibs(state:RawPointer<Lua_State>):Void;

    // helpers

    @:functionCode('
        lua_getglobal(state, "_G");
        luaL_register(state, NULL, printlib);
        lua_pop(state, 1);
    ')
    static function lua_register_hxtrace_lib(state:RawPointer<Lua_State>):Void;

    @:functionCode('
        print_fun = f;
    ')
    static function lua_register_hxtrace_func(f:cpp.Callable<String->Int>):Void;
}

typedef Lua_CFunction = cpp.Callable<(state:RawPointer<Lua_State>) -> Int>;
typedef Lua_Reader = cpp.Callable<(state:RawPointer<Lua_State>, ud:RawPointer<cpp.Void>, sz:RawPointer<SizeT>) -> ConstCharStar>;
typedef Lua_Writer = cpp.Callable<(state:RawPointer<Lua_State>, p:RawConstPointer<cpp.Void>, sz:SizeT, ud:RawPointer<cpp.Void>) -> Int>;
typedef Lua_Alloc = cpp.Callable<(ud:RawPointer<cpp.Void>, ptr:RawPointer<cpp.Void>, osize:SizeT, nsize:SizeT) -> Void>;
typedef Lua_Hook = cpp.Callable<(state:RawPointer<Lua_State>, debugger:RawPointer<Lua_Debug>) -> Void>;
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