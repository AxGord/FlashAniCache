package haxe {
	import flash.Boot;
	public class Log {
		static public var _trace : Function = function(v : *,infos : * = null) : void {
			var pstr : String = ((infos == null)?"(null)":infos.fileName + ":" + infos.lineNumber);
			trace(pstr + ": " + flash.Boot.__string_rec(v,""));
		}
		static public var clear : Function = function() : void {
			flash.Boot.__clear_trace();
		}
		static public var setColor : Function = function(rgb : int) : void {
			flash.Boot.__set_trace_color(rgb);
		}
	}
}
