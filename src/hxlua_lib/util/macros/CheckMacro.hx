package hxlua_lib.util.macros;

#if macro
import haxe.macro.Context;

class CheckMacro
{
	public static function run():Void
	{
		if (!Context.defined('cpp') && !(Context.defined('desktop') || Context.defined('mobile')))
			Context.fatalError('The current target platform isn\'t supported by the hxlua_lib library.', (macro null).pos);

		#if (lime < version("8.0.1"))
		Context.fatalError('The hxlua_lib library requires Lime version 8.0.1 or newer. Please update Lime by running `haxelib update lime`.', (macro null).pos);
		#end

		if (Context.defined('linc_luajit') || Context.defined('hxluajit') || Context.defined('hxlua'))
			Context.fatalError('The hxlua_lib library and linc_luajit/hxluajit/hxlua cannot be used in the same project.', (macro null).pos);
	}
}
#end
