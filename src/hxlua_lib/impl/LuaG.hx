package hxlua_lib.impl;

#if !cpp
#error "Haxelib 'hxlua_lib' supported only in C++ platforms."
#end

import cpp.Callable;
import hxlua_lib.impl.externs.Lua;

@:access(hxlua_lib.impl.Instance)
class LuaG
{
    @:noCompletion
    public static var lastCalledInstance:Null<Instance> = null;
    public static var globalCallbacks:Map<String, Dynamic> = new Map<String, Dynamic>();

    public static inline function addCallback(instance:Instance, funname:String, fun:Dynamic):Bool {
        if (instance.state == null) return false;

        globalCallbacks.set(funname, fun);
        Lua.lua_addcallbackfunction(instance.state, cast funname);

        return true;
    }

    public static inline function removeCallback(instance:Instance, funname:String):Bool {
        if (instance.state == null) return false;

        globalCallbacks.remove(funname);
        Lua.lua_removecallbackfunction(instance.state, cast funname);

        return true;
    }

    public static function callbackHandler(instance:Instance, funname:String):Int {
        if (instance.state == null) return 0;

        try {
            var cbf = globalCallbacks.get(funname);
            if (cbf == null) return 0;

            var nparams:Int = Lua.lua_gettop(instance.state);
            var args:Array<Dynamic> = [];

            for (i in 0...nparams) {
                args[i] = instance.fromLua(i + 1);
            }

            var ret = Reflect.callMethod(null, cbf, args);
            if (ret != null) {
                instance.toLua(ret);
                return 1;
            }
        } catch(e) {
            throw(e);
        }

        return 0;
    }

    static inline function printFunction(s:String):Int {
        LuaG.trace(s);
        return 0;
    }

    public static dynamic function trace(s:Dynamic, ?inf:haxe.PosInfos):Void {
        trace(s, inf);
    }

    public static inline function registerHxTrace(instance:Instance):Void {
        if (instance.state == null) return;

        Lua.lua_registerhxtracefunc(Callable.fromStaticFunction(printFunction));
        Lua.lua_registerhxtracelib(instance.state);
    }

    @:noCompletion
    public static function quickCallbackHandler(cbf:Dynamic, instance:Instance, ?object:Dynamic):Int
    {
        if (instance.state == null) return 0;

        try {
            final l:Lua_State = instance.state;
            final nparams:Int = Lua.lua_gettop(l);

            if (cbf == null) return 0;

            final ret:Dynamic = Reflect.callMethod(object, cbf, [for (i in 0...nparams) instance.fromLua(i+1)]);
            if (ret != null) {
                instance.toLua(ret);
                return 1;
            }
        } catch(e) {
            throw(e);
        }

        return 0;
    }
}