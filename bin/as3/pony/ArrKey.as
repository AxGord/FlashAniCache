package pony {
	import pony.Dictionary;
	import pony.ArrayExtensions;
	import flash.Boot;
	public class ArrKey extends pony.Dictionary {
		public function ArrKey() : void { if( !flash.Boot.skip_constructor ) {
			super();
		}}
		
		protected override function getIndex(_tmp_k : *) : int {
			var k : Array = _tmp_k;
			var len : int = k.length;
			return pony.ArrayExtensions.search(this.ks,function(o : Array) : Boolean {
				{
					var _g : int = 0;
					while(_g < len) {
						var i : int = _g++;
						if(o[i] != k[i]) return false;
					}
				}
				return true;
			});
		}
		
		static public var __meta__ : * = { fields : { _ : { NotAsyncAuto : null}}}
	}
}
