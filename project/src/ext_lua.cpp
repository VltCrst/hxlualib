#include "hxcpp.h"
#include <hx/CFFI.h>
#include "lua.hpp"
#include "ext_lua.hpp"

// From: https://github.com/AndreiRudenko/linc_luajit/blob/master/linc/linc_lua.cpp
namespace ext
{
    namespace lua
    {
        int getinfo(lua_State *L, const char *what, Dynamic ar)
        {

            lua_Debug dbg;

            dbg.i_ci = ar->__FieldRef(HX_CSTRING("i_ci"));

            int ret = lua_getinfo(L, what, &dbg);

            if (strchr(what, 'S'))
            {

                if (dbg.source != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("source")) = ::String(dbg.source);
                }

                if (dbg.short_src != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("short_src")) = ::String(dbg.short_src);
                }

                if (dbg.linedefined != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("linedefined")) = (int)dbg.linedefined;
                }

                if (dbg.lastlinedefined != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("lastlinedefined")) = (int)dbg.lastlinedefined;
                }

                if (dbg.what != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("what")) = ::String(dbg.what);
                }
            }

            if (strchr(what, 'n'))
            {
                if (dbg.name != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("name")) = ::String(dbg.name);
                }

                if (dbg.namewhat != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("namewhat")) = ::String(dbg.namewhat);
                }
            }

            if (strchr(what, 'l'))
            {
                if (dbg.currentline != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("currentline")) = (int)dbg.currentline;
                }
            }

            if (strchr(what, 'u'))
            {
                if (dbg.nups != NULL)
                {
                    ar->__FieldRef(HX_CSTRING("nups")) = (int)dbg.nups;
                }
            }

            return ret;
        }

        int getstack(lua_State *L, int level, Dynamic ar)
        {

            lua_Debug dbg;

            int ret = lua_getstack(L, level, &dbg);

            ar->__FieldRef(HX_CSTRING("i_ci")) = (int)dbg.i_ci;

            return ret;
        }
    }

    namespace hxtrace
    {

        static int onError(lua_State *L)
        {

            const char *msg = lua_tostring(L, 1);

            if (msg)
                luaL_traceback(L, L, msg, 1);
            else if (!lua_isnoneornil(L, 1))
            {
                if (!luaL_callmeta(L, 1, "__tostring"))
                    lua_pushliteral(L, "(NO ERROR)");
            }

            return 1;
        }

        int seterrorhandler(lua_State *L)
        {
            lua_pushcfunction(L, onError);
            return 1;
        }

        static HxTraceFun print_fn = 0;
        static int hx_trace(lua_State *L)
        {

            std::stringstream buffer;
            int n = lua_gettop(L);

            lua_getglobal(L, "tostring");

            for (int i = 1; i <= n; ++i)
            {
                const char *s = NULL;
                size_t l = 0;

                lua_pushvalue(L, -1);
                lua_pushvalue(L, i);
                lua_call(L, 1, 1);

                s = lua_tolstring(L, -1, &l);
                if (s == NULL)
                {
                    return luaL_error(L, LUA_QL("tostring") " must return a string to " LUA_QL("print"));
                }

                if (i > 1)
                {
                    buffer << "\t";
                }

                buffer << s;

                lua_pop(L, 1);
            }

            print_fn(::String(buffer.str().c_str()));

            return 0;
        }

        static const struct luaL_Reg printlib[] = {

            {"print", hx_trace},
            {NULL, NULL}

        };

        void registerhxtracefunc(HxTraceFun fn)
        {
            print_fn = fn;
        }

        void registerhxtracelib(lua_State *L)
        {

            lua_getglobal(L, "_G");
            luaL_register(L, NULL, printlib);
            lua_pop(L, 1);
        }

    }

    
    namespace callbacks {
        static luaCallbackFun event_fn = 0;
        static int luacallback(lua_State *L) {

            return event_fn(L, ::String(lua_tostring(L, lua_upvalueindex(1))));

        }

        void setcallbacksfunction(luaCallbackFun fn) {

            event_fn = fn;

        }

        void addcallbackfunction(lua_State *L, const char *name)
        {

            lua_pushstring(L, name);
            lua_pushcclosure(L, luacallback, 1);
            lua_setglobal(L, name);

        }

        void removecallbackfunction(lua_State *L, const char *name)
        {

            lua_pushnil(L);
            lua_setglobal(L, name);

        }
    }
}