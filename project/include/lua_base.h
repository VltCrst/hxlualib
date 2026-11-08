#pragma once

#ifndef lua_base_h
#define lua_base_h 1

#if defined (_WIN32) && defined (DLL_EXPORT)
# define LUA_API __declspec(dllexport)
#elif defined (__GNUC__) && (__GNUC__ >= 4)
# define LUA_API __attribute__((visibility("default")))
#else
# define LUA_API
#endif

#include <hxcpp.h>
#include <hx/CFFI.h>

#include <sstream>
#include <iostream>

#include "lua.h"
#include "luajit.h"

# ifdef __cplusplus
extern "C" {
# endif

LUA_API const char *luabase_version(void);
LUA_API const char *luabase_versionJIT(void);
LUA_API const char *luabase_tostring(lua_State *l, int v);
LUA_API const char *luabase_tolstring(lua_State *l, int v, size_t *len);
LUA_API const char *luabase__typename(lua_State *l, int tp);

LUA_API int luabase_getstack(lua_State *L, int level, Dynamic ar);
LUA_API int luabase_getinfo(lua_State *L, const char *info, Dynamic ar);

LUA_API const char *luabasel_checklstring(lua_State *l, int numArg, size_t *len);

# ifdef __cplusplus
}
# endif
#endif