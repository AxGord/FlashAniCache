package haxe {
	import haxe.io.Bytes;
	import flash.Boot;
	public class BaseCode {
		public function BaseCode(base : haxe.io.Bytes = null) : void { if( !flash.Boot.skip_constructor ) {
			var len : int = base.length;
			var nbits : int = 1;
			while(len > 1 << nbits) nbits++;
			if(nbits > 8 || len != 1 << nbits) throw "BaseCode : base length must be a power of two.";
			this.base = base;
			this.nbits = nbits;
		}}
		
		public function decodeString(s : String) : String {
			return this.decodeBytes(haxe.io.Bytes.ofString(s)).toString();
		}
		
		public function encodeString(s : String) : String {
			return this.encodeBytes(haxe.io.Bytes.ofString(s)).toString();
		}
		
		public function decodeBytes(b : haxe.io.Bytes) : haxe.io.Bytes {
			var nbits : int = this.nbits;
			var base : haxe.io.Bytes = this.base;
			if(this.tbl == null) this.initTable();
			var tbl : Array = this.tbl;
			var size : int = b.length * nbits >> 3;
			var out : haxe.io.Bytes = haxe.io.Bytes.alloc(size);
			var buf : int = 0;
			var curbits : int = 0;
			var pin : int = 0;
			var pout : int = 0;
			while(pout < size) {
				while(curbits < 8) {
					curbits += nbits;
					buf <<= nbits;
					var i : int = tbl[b.get(pin++)];
					if(i == -1) throw "BaseCode : invalid encoded char";
					buf |= i;
				}
				curbits -= 8;
				out.set(pout++,buf >> curbits & 255);
			}
			return out;
		}
		
		protected function initTable() : void {
			var tbl : Array = new Array();
			{
				var _g : int = 0;
				while(_g < 256) {
					var i : int = _g++;
					tbl[i] = -1;
				}
			}
			{
				var _g1 : int = 0, _g2 : int = this.base.length;
				while(_g1 < _g2) {
					var i1 : int = _g1++;
					tbl[this.base.get(i1)] = i1;
				}
			}
			this.tbl = tbl;
		}
		
		public function encodeBytes(b : haxe.io.Bytes) : haxe.io.Bytes {
			var nbits : int = this.nbits;
			var base : haxe.io.Bytes = this.base;
			var size : int = Std._int(b.length * 8 / nbits);
			var out : haxe.io.Bytes = haxe.io.Bytes.alloc(size + (((b.length * 8 % nbits == 0)?0:1)));
			var buf : int = 0;
			var curbits : int = 0;
			var mask : int = (1 << nbits) - 1;
			var pin : int = 0;
			var pout : int = 0;
			while(pout < size) {
				while(curbits < nbits) {
					curbits += 8;
					buf <<= 8;
					buf |= b.get(pin++);
				}
				curbits -= nbits;
				out.set(pout++,base.get(buf >> curbits & mask));
			}
			if(curbits > 0) out.set(pout++,base.get(buf << nbits - curbits & mask));
			return out;
		}
		
		protected var tbl : Array;
		protected var nbits : int;
		protected var base : haxe.io.Bytes;
		static public function encode(s : String,base : String) : String {
			var b : haxe.BaseCode = new haxe.BaseCode(haxe.io.Bytes.ofString(base));
			return b.encodeString(s);
		}
		
		static public function decode(s : String,base : String) : String {
			var b : haxe.BaseCode = new haxe.BaseCode(haxe.io.Bytes.ofString(base));
			return b.decodeString(s);
		}
		
	}
}
