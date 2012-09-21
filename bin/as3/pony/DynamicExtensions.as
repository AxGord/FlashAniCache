package pony {
	import haxe.rtti.Meta;
	import haxe.Log;
	public class DynamicExtensions {
		static public function notNull(o : *) : Boolean {
			return o != null;
		}
		
		static public function isNull(o : *) : Boolean {
			return o == null;
		}
		
		static public function clone(o : *) : * {
			if(o == null) return null;
			{
				var $e : enum = (Type._typeof(o));
				switch( $e.index ) {
				case 6:
				var Void : Class = $e.params[0];
				break;
				case 7:
				var Void1 : Class = $e.params[0];
				break;
				case 4:
				break;
				case 8:
				{
					var b : Boolean = false;
					try {
						b = o == [] || o[0] != null;
					}
					catch( e : * ){
						return o;
					}
					if(b) {
						var i : int = 0;
						var n : * = [];
						while(o[i] != null) {
							n[i] = pony.DynamicExtensions.clone(o[i]);
							i++;
						}
						n = Reflect.field(n,"__a");
						return n;
					}
					return o;
				}
				break;
				default:
				return o;
				break;
				}
			}
			var n1 : * = Reflect.copy(o);
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(n1);
				while(_g < _g1.length) {
					var f : String = _g1[_g];
					++_g;
					Reflect.setField(n1,f,pony.DynamicExtensions.clone(Reflect.field(n1,f)));
				}
			}
			return n1;
		}
		
		static public function _is(o : *,c : Class) : Boolean {
			if(Std._is(o,c)) return true;
			try {
				var meta : * = haxe.rtti.Meta.getType(Type.getClass(o));
				if(Reflect.hasField(meta,"extends")) {
					var exts : Array = Reflect.field(meta,"extends");
					haxe.Log._trace(exts,{ fileName : "Ultra.hx", lineNumber : 272, className : "pony.DynamicExtensions", methodName : "is"});
					{
						var _g : int = 0;
						while(_g < exts.length) {
							var e : String = exts[_g];
							++_g;
							if(e == c.__name__[0]) return true;
						}
					}
				}
			}
			catch( e1 : * ){
			}
			return false;
		}
		
	}
}
