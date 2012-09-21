package flash.utils {
	import flash.utils.Dictionary;
	import flash.Boot;
	public class TypedDictionary extends flash.utils.Dictionary {
		public function TypedDictionary(weakKeys : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(weakKeys);
		}}
		
		public function iterator() : * {
			return this.keys().iterator();
		}
		
		public function keys() : Array {
			return (function($this:TypedDictionary) : Array {
				var $r : Array;
				$r = new Array();
				for(var $k2 : String in $this) $r.push($k2);
				return $r;
			}(this));
		}
		
		public function _delete(k : *) : void {
			delete(this[k]);
		}
		
		public function exists(k : *) : * {
			return this[k] != null;
		}
		
		public function set(k : *,v : *) : void {
			this[k] = v;
		}
		
		public function get(k : *) : * {
			return this[k];
		}
		
	}
}
