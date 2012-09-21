package  {
	import touchmypixel.bitmap.Animation;
	import pony.SpeedLimit;
	import touchmypixel.bitmap.AnimationCache;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.Boot;
	import flash.display.DisplayObject;
	public class AniCache extends ExtendedMovieClip {
		public function AniCache() : void { if( !flash.Boot.skip_constructor ) {
			this.ac = true;
			super();
			this.stop();
			var v : Array = FLTools.getVersion();
			if(v[0] == 11 && v[1] >= 2 || v[0] > 11) this.quality = "16X16";
			else this.quality = "BEST";
			this.addEventListener(flash.events.Event.ADDED_TO_STAGE,this.init);
		}}
		
		protected override function _gotoAndStop(frame : *,scene : String = null) : void {
			if(!Std._is(frame,int)) throw "frame can be only Int type";
			if(this.prClip != null) {
				var f : int = frame;
				this.prClip.gotoAndStop(f);
			}
		}
		
		protected override function _gotoAndPlay(frame : *,scene : String = null) : void {
			if(!Std._is(frame,int)) throw "frame can be only Int type";
			if(this.prClip != null) {
				var f : int = frame;
				this.prClip.gotoAndPlay(f);
			}
		}
		
		public override function play() : void {
			if(this.prClip != null) this.prClip.play();
		}
		
		public override function stop() : void {
			if(this.prClip != null) this.prClip.stop();
			else super.stop();
		}
		
		protected function _resize() : void {
			var q : String = this.stage.quality;
			this.stage.quality = this.quality;
			var mx : Number = 1;
			var my : Number = 1;
			var t : flash.display.DisplayObject = this;
			while(Std._is(t,flash.display.MovieClip)) {
				mx *= t.scaleX;
				my *= t.scaleY;
				t = t.parent;
			}
			if(mx == this.lmx && my == this.lmy) return;
			while(this.numChildren > 0) this.removeChildAt(0);
			var animationCache : touchmypixel.bitmap.AnimationCache = touchmypixel.bitmap.AnimationCache.getInstance();
			var clip : touchmypixel.bitmap.Animation = animationCache.cacheAnimation(this.n,this.mc,Math.ceil(mx * 100) / 100,Math.ceil(my * 100) / 100);
			clip.scaleX = 1 / mx;
			clip.scaleY = 1 / my;
			clip.x = 0;
			clip.y = 0;
			if(this.prClip != null) {
				if(this.prClip.isPlaying()) clip.gotoAndPlay(this.prClip.currentFrame);
				else clip.gotoAndStop(this.prClip.currentFrame);
			}
			else clip.play();
			this.addChild(this.prClip = clip);
			this.stage.quality = q;
		}
		
		public function resize(event : flash.events.Event = null) : void {
			this.sl.abort();
			this.sl.run(this._resize);
		}
		
		protected function added(event : flash.events.Event) : void {
			var t : flash.display.DisplayObject = this;
			while(Std._is(t,flash.display.MovieClip)) {
				t.addEventListener(flash.events.Event.RESIZE,this.resize);
				t = t.parent;
			}
			this.stage.addEventListener(flash.events.Event.RESIZE,this.resize);
			this.stage.addEventListener(flash.events.FullScreenEvent.FULL_SCREEN,this.resize);
			this.resize();
		}
		
		protected function init(event : flash.events.Event) : void {
			if(!this.ac) return;
			while(this.numChildren > 0) this.removeChildAt(0);
			this.sl = new pony.SpeedLimit(200);
			var cl : Class = Type.getClass(this);
			this.n = Type.getClassName(cl);
			this.mc = Type.createInstance(cl,[]);
			this.mc.addEventListener(flash.events.Event.ADDED_TO_STAGE,this.added);
			this.mc.ac = false;
			this.addChild(this.mc);
		}
		
		protected var tid : int;
		protected var mc : AniCache;
		protected var n : String;
		public var ac : Boolean;
		protected var prClip : touchmypixel.bitmap.Animation;
		protected var lmy : Number;
		protected var lmx : Number;
		public var quality : String;
		protected var sl : pony.SpeedLimit;
		protected var a : Array;
	}
}
