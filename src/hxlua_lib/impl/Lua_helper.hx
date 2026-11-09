package hxlua_lib.impl;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

import cpp.RawPointer;
import hxlua_lib.impl.externs.Lua;

class Lua_helper
{
    static inline function print_function(s:String):Int {
        Lua_helper.trace(s);
        return 0;
    }

    public static function register_hxtrace(state:RawPointer<Lua_State>):Void {
        Lua.lua_register_hxtrace_func(cpp.Callable.fromStaticFunction(print_function));
        Lua.lua_register_hxtrace_lib(state);
    }

    public static dynamic function trace(s:String, ?inf:haxe.PosInfos):Void {
        haxe.Log.trace(s, inf);
    }

    public static var global_callbacks:Map<String, Dynamic> = [];

    public static function add_callback(state:RawPointer<Lua_State>, fname:String, f:Dynamic):Bool {
        global_callbacks.set(fname, f);
        Lua.lua_add_callback_function(state, fname);
        return true;
    }

    public static function remove_callback(state:RawPointer<Lua_State>, fname:String):Bool {
        if (global_callbacks.exists(fname)) global_callbacks.remove(fname);
        Lua.lua_remove_callback_function(state, fname);
        return true;
    }

    
}