package pony {
	import pony.magic.Declarator;
	import flash.Boot;
	public class Dictionary implements pony.magic.Declarator{
		public function Dictionary() : void { if( !flash.Boot.skip_constructor ) {
			this.ks = [];
			this.vs = [];
		}}
		
		public function removeValue(v : *) : void {
			var i : int = Lambda.indexOf(this.vs,v);
			if(i != -1) {
				this.ks.splice(i,1);
				this.vs.splice(i,1);
			}
		}
		
		public function toString() : String {
			var a : Array = [];
			{ var $it : * = this.keys();
			while( $it.hasNext() ) { var k : * = $it.next();
			a.push(Std.string(k) + ": " + Std.string(this.get(k)));
			}}
			return "[" + a.join(", ") + "]";
		}
		
		public function keys() : * {
			return this.ks.iterator();
		}
		
		public function iterator() : * {
			return this.vs.iterator();
		}
		
		public function clear() : void {
			this.ks = [];
			this.vs = [];
		}
		
		public function remove(k : *) : void {
			var i : int = this.getIndex(k);
			if(i != -1) {
				this.ks.splice(i,1);
				this.vs.splice(i,1);
			}
		}
		
		public function exists(k : *) : Boolean {
			return this.getIndex(k) != -1;
		}
		
		public function get(k : *) : * {
			var i : int = this.getIndex(k);
			if(i == -1) return null;
			else return this.vs[i];
			return null;
		}
		
		public function set(k : *,v : *) : void {
			var i : int = this.getIndex(k);
			if(i != -1) this.vs[i] = v;
			else {
				this.ks.push(k);
				this.vs.push(v);
			}
		}
		
		protected function getIndex(k : *) : int {
			return Lambda.indexOf(this.ks,k);
		}
		
		public var vs : Array;
		public var ks : Array;
		static public var __meta__ : * = { fields : { _ : { NotAsyncAuto : null}}}
	}
}
