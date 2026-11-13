package hxlua_lib.impl;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

import cpp.Pointer;
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
import haxe.DynamicAccess;

import hxlua_lib.impl.externs.Lua;
import hxlua_lib.util.Types;
import hxlua_lib.impl.externs.Table.*;

using StringTools;
using hxlua_lib.util.Tools;

// TODO: Complete with more methods and some helpers here
@:cppInclude('stdarg.h')
class Instance {
    /**
     * Calls, variables, and more lua methods in this variable.
     */
    @:noCompletion
    public var state:Null<Lua_State>;

    /**
     * This lua is closed or no?
     * After `close` method, `state` and lua script will close.
     */
    public var closed:Bool = false;

    /**
     * Local callbacks.
     * Use `setCallback` method, for adding callback to lua.
     * If just set to `callbacks` some method, it's will not working to lua.
     */
    public var callbacks:Map<String, Dynamic> = new Map<String, Dynamic>();

    /**
     * Local variables.
     */
    public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();

    /**
     * Local last called function.
     */
    public var lastCalledFunc:String = "n/a";

    /**
     * Lua state initialize.
     */
    public function new():Void
    {
        state = Lua.lua_open();
        Lua.luaL_openlibs(state);
    }

    /**
     * Add callback function to local `callbacks`, to global `LuaG.globalCallbacks` and for lua script.
     * @param fun Callback name. (`'init'` for example)
     * @param data Callback method. (`(msg:String) -> {trace(msg);}` for example)
     */
    public function setCallback(fun:String, data:Dynamic) {
        if (state == null) return;

        callbacks.set(fun, data);
        setGlobalCallback(fun, data);
    }

    /**
     * Add callback function to global `LuaG.globalCallbacks` and for lua script.
     * @param fun Callback name. (`'init'` for example)
     * @param data Callback method. (`(msg:String) -> {trace(msg);}` for example)
     */
    public function setGlobalCallback(fun:String, data:Dynamic) {
        if (state == null) return;

        LuaG.addCallback(this, fun, data);
    }

    /**
     * Set variable name and data for lua.
     * @param variable Variable name. (`'cof'` for example)
     * @param data Variable data. (`0`, `'hello world`', `[0, 1, 2]`, for example)
     */
    public function set(variable:String, data:Dynamic) {
        if (state == null) return;

        variables.set(variable, data);
        toLua(data);
        Lua.lua_setglobal(state, variable);
    }

    /**
     * Calling exists callback method from lua.
     * @param func Method name from lua.
     * @param args Method arguments. (If not exists, set to `[]`.)
     * @return Int
     */
    public function call(func:String, args:Array<Dynamic>):Int {
        if (closed || state == null) return -1;

        lastCalledFunc = func;
        LuaG.lastCalledInstance = this;

        try {
            Lua.lua_getglobal(state, func);
            var type:Int = Lua.lua_type(state, -1);
            if (type != LUA_TFUNCTION)
            {
                if (type > cast(LUA_TNIL, Int))
                    trace(' [LUA] Error: ${func} type is ${type.typeToString()} value.');

                Lua.lua_pop(state, 1);
                return -1;
            }

            for (arg in args) toLua(arg);
            var status:Int = Lua.lua_pcall(state, args.length, 1, 0);
            if (status != LUA_OK) {
                trace(' [LUA] (${func}): ${status.threadToString()}');
                return -1;
            }

            var result:Dynamic = fromLua(-1);
            if (result == null) result = -1;

            Lua.lua_pop(state, 1);
            if (closed) close();
            return result;
        } catch(e) {
            throw(e);
        }

        return -1;
    }

    public function close():Void {
        closed = true;

        if (state == null) return;
        Lua.lua_close(state);
        state = null;
    }

    @:noCompletion
    public function toLua(val:Any):Bool {
        if (state == null) return false;

        switch (Type.typeof(val)) {
            case TNull:
                Lua.lua_pushnil(state);
            case TBool:
                Lua.lua_pushboolean(state, val);
            case TInt:
                Lua.lua_pushinteger(state, cast(val, Int));
            case TFloat:
                Lua.lua_pushnumber(state, cast(val, Float));
            case TClass(String):
                Lua.lua_pushstring(state, cast(val, String));
            case TClass(Array):
                var arr:Array<Any> = val;
                Lua.lua_createtable(state, arr.length, 0);
                for (i => v in arr) {
                    Lua.lua_pushnumber(state, i + 1);
                    toLua(v);
                    Lua.lua_settable(state, -3);
                }
            case TClass(haxe.ds.StringMap) | TClass(haxe.ds.ObjectMap):
                var res:Map<String, Dynamic> = val;
                Lua.lua_createtable(state, 0, 0);
                for (i => v in res) {
                    Lua.lua_pushstring(state, Std.string(i));
                    toLua(v);
                    Lua.lua_settable(state, -3);
                }
            case TObject:
                Lua.lua_createtable(state, 0, 0);
                for (n in Reflect.fields(val)) {
                    Lua.lua_pushstring(state, n);
                    toLua(Reflect.field(val, n));
                    Lua.lua_settable(state, -3);
                }
            default:
                return false;
        }

        return true;
    }

    @:noCompletion
    public function getInfo(w:String)
    {
        if (state == null) return;

        Lua.lua_getinfo(state, w, {
            event: 0
        });
    }

    @:noCompletion
    public function fromLua(v:Int):Any {
        if (state == null) return {};

        final luaType = luaType(v);
        return switch(luaType) {
            case LUA_TNIL:
                null;
            case LUA_TBOOLEAN:
                luaToBool(v);
            case LUA_TNUMBER:
                luaToNumber(v);
            case LUA_TSTRING:
                luaToString(v);
            case LUA_TTABLE:
                toHaxeObj(v);
            case LUA_TFUNCTION:
                new Callback(this, luaLRef(LUA_REGISTRYINDEX));
            default:
                null;
        }
    }

    public function getBool(variable:String):Bool {
        if (state == null) return false;
        
        var result:Null<String> = null;
        Lua.lua_getglobal(state, variable);
        result = fromLua(-1);
        Lua.lua_pop(state, 1);

        if (result == null) return false;
        return (result.toLowerCase() == 'true');
    }

    @:noCompletion
    public function luaLRef(idx:Int):Int
    {
        if (state == null) return 0;
        return Lua.luaL_ref(state, idx);
    }

    @:noCompletion
    public function luaToBool(idx:Int):Bool
    {
        if (state == null) return false;
        return Lua.lua_toboolean(state, idx);
    }

    @:noCompletion
    public function luaType(idx:Int):LuaType
    {
        if (state == null) return -1;
        return Lua.lua_type(state, idx);
    }

    @:noCompletion
    public function luaToNumber(idx:Int):Float
    {
        if (state == null) return 0.0;
        return Lua.lua_tonumber(state, idx);
    }

    @:noCompletion
    public function luaToString(idx:Int):String {
        if (state == null) return "";
        return Lua._lua_tostring(state, idx);
    }

    @:noCompletion
    public function toHaxeObj(i:Int):Any {
        if (state == null) return {};

        var hasItems:Bool = false;
        var isArray:Bool = false;

        loopTable(state, i, {
            hasItems = true;
            if (luaType(-2) != LUA_TNUMBER) {
                isArray = false;
            }

            final index = luaToNumber(-2);
            if (index < 0 || Std.int(index) != index) {
                isArray = false;
            }
        });
        if (!hasItems) return {};

        if (isArray) {
            final v:Array<Dynamic> = [];
            loopTable(state, i, {
                v[Std.int(luaToNumber(-2)) - 1] = fromLua(-1);
            });
            return cast v;
        }

        final v:DynamicAccess<Any> = {};
        loopTable(state, i, {
            switch luaType(-2) {
                case t if(t == LUA_TSTRING): v.set(luaToString(-2), fromLua(-1));
                case t if(t == LUA_TNUMBER): v.set(Std.string(luaToNumber(-2)), fromLua(-1));
            }
        });
        return v;
    }
}

@:cppInclude('stdarg.h')
class Callback {
    public var ref:Int = 0;

    @:noCompletion
    public var instance:Null<Instance> = null;

    public function new(instance:Instance, ref:Int) {
        this.instance = instance;
        this.ref = ref;
    }

    public function call(args:Array<Dynamic> = null) {
        if (instance == null || instance.state == null) return;

        Lua.lua_rawgeti(instance.state, LUA_REGISTRYINDEX, this.ref);
        if (Lua.lua_isfunction(instance.state, -1)) {
            if (args == null) args = [];
            for (arg in args) instance.toLua(arg);

            var status:Int = Lua.lua_pcall(instance.state, args.length, 1, 0);
            if (status != LUA_OK) {
                Lua.lua_pop(instance.state, 1);
                trace(' [LUA CALLBACK] ${status.threadToString()}');
            }
        }
    }

    public function dispose() {
        if (instance == null || instance.state == null) return;

        Lua.luaL_unref(instance.state, LUA_REGISTRYINDEX, ref);
    }
}