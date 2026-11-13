#pragma once

#include <hxcpp.h>
#include <hx/CFFI.h>

#include <sstream>
#include <iostream>

#include "lua.hpp"

namespace ext
{
    typedef ::cpp::Function<int(::cpp::Reference<lua_State>, ::String)> luaCallbackFun;
    typedef ::cpp::Function<int(String)> HxTraceFun;

    namespace lua
    {
        extern int getinfo(lua_State *L, const char *what, Dynamic ar);
        extern int getstack(lua_State *L, int level, Dynamic ar);
    }

    namespace hxtrace {
        extern int seterrorhandler(lua_State *L);
        extern void registerhxtracefunc(HxTraceFun fn);
        extern void registerhxtracelib(lua_State *L);
    }

    namespace callbacks {
        extern void setcallbacksfunction(luaCallbackFun fn);
        extern void addcallbackfunction(lua_State *L, const char *name);
        extern void removecallbackfunction(lua_State *L, const char *name);
    }
}