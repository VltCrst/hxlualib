#if defined(_WIN32) && defined(DLL_EXPORT)
#define LUA_API __declspec(dllexport)
#elif defined(__GNUC__) && (__GNUC__ >= 4)
#define LUA_API __attribute__((visibility("default")))
#else
#define LUA_API
#endif

#include <hxcpp.h>
#include <hx/CFFI.h>

#include "./lua_base.h"
#include "./luajit.h"
#include "./lua.h"

LUA_API const char *luabase_version()
{
    return ::String(LUA_VERSION);
}
LUA_API const char *luabase_versionJIT()
{
    return ::String(LUAJIT_VERSION);
}
LUA_API const char *luabase_tostring(lua_State *l, int v)
{
    return ::String(lua_tostring(l, v));
}
LUA_API const char *luabase_tolstring(lua_State *l, int v, size_t *len)
{
    return ::String(lua_tolstring(l, v, len));
}
LUA_API const char *luabase__typename(lua_State *l, int tp)
{
    return ::String(lua_typename(l, v));
}

LUA_API int luabase_getstack(lua_State *L, int level, Dynamic ar)
{
    lua_Debug dbg;

    int ret = lua_getstack(L, level, &dbg);
    ar->__FieldRef(HX_CSTRING("i_ci")) = (int)dbg.i_ci;

    return ret;
}
LUA_API int luabase_getinfo(lua_State *L, const char *info, Dynamic ar)
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

LUA_API const char *luabasel_checklstring(lua_State *l, int numArg, size_t *len) {
    return ::String(luaL_checklstring(l, numArg, len));
}