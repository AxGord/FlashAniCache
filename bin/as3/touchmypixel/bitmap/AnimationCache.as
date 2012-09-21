package touchmypixel.bitmap {
	import touchmypixel.events.ProcessEvent;
	import touchmypixel.bitmap.Animation;
	import flash.events.EventDispatcher;
	import pony.SpeedLimit;
	import flash.display.MovieClip;
	import haxe.Log;
	import pony.ArrKey;
	import flash.system.System;
	import flash.Boot;
	public class AnimationCache extends flash.events.EventDispatcher {
		public function AnimationCache() : void { if( !flash.Boot.skip_constructor ) {
			this.sl = new pony.SpeedLimit(touchmypixel.bitmap.AnimationCache.clearDelay);
			super();
			touchmypixel.bitmap.AnimationCache.instance = this;
			this.animations = new pony.ArrKey();
			this.cacheQueue = new Array();
			this.replaceExisting = false;
		}}
		
		public function clearAll() : void {
			{ var $it : * = this.animations.iterator();
			while( $it.hasNext() ) { var v : touchmypixel.bitmap.Animation = $it.next();
			v.destroy();
			}}
			this.animations = new pony.ArrKey();
		}
		
		protected function process() : void {
			haxe.Log._trace("process",{ fileName : "AnimationCache.hx", lineNumber : 109, className : "touchmypixel.bitmap.AnimationCache", methodName : "process"});
			var item : * = this.cacheQueue[this.currentlyProcessingItem++];
			if(item != null) {
				this.cacheAnimation(item.id,item.clip);
				this.dispatchEvent(new touchmypixel.events.ProcessEvent("progress",this.currentlyProcessingItem / this.cacheQueue.length));
				this.process();
			}
			else {
				this.dispatchEvent(new touchmypixel.events.ProcessEvent("complete"));
				this.cacheQueue = [];
			}
		}
		
		public function processQueue() : void {
			this.currentlyProcessingItem = 0;
			this.dispatchEvent(new touchmypixel.events.ProcessEvent("start"));
			this.process();
		}
		
		public function addToCacheQueue(id : String,clip : flash.display.MovieClip) : void {
			this.cacheQueue.push({ id : id, clip : clip});
		}
		
		public function getAnimation(id : String,sX : Number = 1,sY : Number = 1) : touchmypixel.bitmap.Animation {
			var cachedAnimation : touchmypixel.bitmap.Animation = this.animations.get([id,sX,sY]);
			if(cachedAnimation == null) {
				haxe.Log._trace("MISSING ANIMATION (AnimationCache): " + id,{ fileName : "AnimationCache.hx", lineNumber : 82, className : "touchmypixel.bitmap.AnimationCache", methodName : "getAnimation"});
				return null;
			}
			var animation : touchmypixel.bitmap.Animation = new touchmypixel.bitmap.Animation();
			animation.frames = cachedAnimation.frames;
			animation.bitmap.x = cachedAnimation.bitmap.x;
			animation.bitmap.y = cachedAnimation.bitmap.y;
			animation.clip = cachedAnimation.clip;
			animation.gotoAndStop(1);
			return animation;
		}
		
		protected function testMemory() : void {
			if(flash.system.System.totalMemory > touchmypixel.bitmap.AnimationCache.clearMem) this.animations.clear();
		}
		
		public function cacheAnimation(id : String,clip : flash.display.MovieClip,sX : Number = 1,sY : Number = 1) : touchmypixel.bitmap.Animation {
			var animation : touchmypixel.bitmap.Animation = null;
			var k : Array = [id,sX,sY];
			if(this.replaceExisting || !this.animations.exists(k)) {
				animation = new touchmypixel.bitmap.Animation(sX,sY);
				animation.buildCacheFromClip(clip);
				this.animations.set(k,animation);
			}
			else animation = this.getAnimation(id,sX,sY);
			this.sl.abort();
			this.sl.run(this.testMemory);
			return animation;
		}
		
		protected var sl : pony.SpeedLimit;
		public var animations : pony.ArrKey;
		public var replaceExisting : Boolean;
		public var currentlyProcessingItem : int;
		public var cacheQueue : Array;
		static public var clearDelay : int = 200;
		static public var clearMem : int = 314572800;
		static protected var instance : touchmypixel.bitmap.AnimationCache;
		static public function getInstance() : touchmypixel.bitmap.AnimationCache {
			return ((touchmypixel.bitmap.AnimationCache.instance == null)?new touchmypixel.bitmap.AnimationCache():touchmypixel.bitmap.AnimationCache.instance);
		}
		
	}
}
