package hxlua_lib.impl.externs;

import haxe.macro.Expr;

class Table {
    public static macro function loopTable(l:Expr, v:Expr, body:Expr) {
        if (l == null) return macro {};
        
        return macro {
            Lua.lua_pushnil($l);
            var p = true;
            while (Lua.lua_next($l, $v < 0 ? $v - 1 : $v) != 0) {
                p = false;
                $body;
                p = true;
                Lua.lua_pop($l, 1);
            }
            if (!p) Lua.lua_pop($l, 1);
        }
    }
}