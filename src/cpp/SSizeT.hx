package cpp;

#if windows
@:include('lua.h')
#end
@:native("ssize_t")
@:scalar
@:coreType
@:notNull
extern abstract SSizeT from Int to Int {}
