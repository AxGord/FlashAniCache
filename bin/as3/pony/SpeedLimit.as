package pony {
	import haxe.Timer;
	import flash.Boot;
	public class SpeedLimit {
		public function SpeedLimit(delay : int = 0) : void { if( !flash.Boot.skip_constructor ) {
			this.setDelay(delay);
		}}
		
		public function setDelay(d : int) : int {
			if(this.delay == d) return d;
			if(d < -1) throw "delay can't be < -1";
			if(this.timer != null) {
				if(d < this.delay) {
					this.timer.run();
					this.abort();
				}
				else {
					var f : Function = this.timer.run;
					this.timer.stop();
					this.timer = new haxe.Timer(d);
					this.timer.run = f;
				}
			}
			return this.$delay = d;
		}
		
		public function abort() : void {
			if(this.timer == null) return;
			this.timer.stop();
			this.timer = null;
		}
		
		public function run(f : Function) : void {
			var _g : pony.SpeedLimit = this;
			if(this.delay == -1) f();
			else {
				if(this.timer == null) this.timer = new haxe.Timer(this.delay);
				this.timer.run = function() : void {
					_g.abort();
					f();
				}
			}
		}
		
		protected var timer : haxe.Timer;
		public function get delay() : int { return $delay; }
		public function set delay( __v : int ) : void { setDelay(__v); }
		protected var $delay : int;
		static public function nextTick(f : Function) : void {
			var sl : pony.SpeedLimit = new pony.SpeedLimit();
			sl.run(f);
		}
		
	}
}
