package pony {
	import pony.BoolExtensions;
	import pony.DynamicExtensions;
	public class ArrayExtensions {
		static public function notNullCount(a : Array) : int {
			var s : int = 0;
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					s += pony.BoolExtensions.toInt(pony.DynamicExtensions.notNull(e));
				}
			}
			return s;
		}
		
		static public function nullCount(a : Array) : int {
			var s : int = 0;
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					s += pony.BoolExtensions.toInt(pony.DynamicExtensions.isNull(e));
				}
			}
			return s;
		}
		
		static public function onlyOne(a : Array) : Boolean {
			return pony.ArrayExtensions.notNullCount(a) == 1;
		}
		
		static public function argCase(a : Array,f : Boolean = true) : int {
			if(!pony.ArrayExtensions.onlyOne(a)) {
				if(f) throw "Give me only one argument";
				else return -2147483648;
			}
			{
				var _g1 : int = 0, _g : int = a.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					if(a[i] != null) return i + 1;
				}
			}
			if(f) throw "Give me only one argument";
			return -2147483648;
		}
		
		static public function last(a : Array) : * {
			return a[a.length - 1];
		}
		
		static public function map(a : Array,f : Function) : Array {
			var na : Array = [];
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					na.push(f(e));
				}
			}
			return na;
		}
		
		static public function quote(a : Array,q : String = "\"") : Array {
			if(q==null) q="\"";
			return pony.ArrayExtensions.map(a,function(s : String) : String {
				return q + s + q;
			});
		}
		
		static public function search(a : Array,f : Function) : int {
			{
				var _g1 : int = 0, _g : int = a.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					if(f(a[i])) return i;
				}
			}
			return -1;
		}
		
	}
}
