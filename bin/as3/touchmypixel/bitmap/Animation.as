package touchmypixel.bitmap {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.Boot;
	public class Animation extends flash.display.Sprite {
		public function Animation(sX : Number = 1,sY : Number = 1) : void { if( !flash.Boot.skip_constructor ) {
			this.sX = sX;
			this.sY = sY;
			super();
			this.frames = [];
			this.currentFrame = 1;
			this.cache = true;
			this.repeat = true;
			this.reverse = false;
			this.treatAsLoopedGraphic = false;
			this._playing = false;
			this.bitmap = new flash.display.Bitmap();
			this.bitmap.smoothing = false;
			this.addChild(this.bitmap);
		}}
		
		public function destroy() : void {
			this.stop();
			if(this.parent != null) this.parent.removeChild(this);
		}
		
		public function update() : void {
			this.stop();
			this.frames = [];
			this.buildCacheFromClip(this.clip);
		}
		
		public function enterFrame(e : flash.events.Event = null) : void {
			if(this.reverse) this.prevFrame();
			else this.nextFrame();
			if(this.currentFrame == this.getTotalFrames()) {
				if(!this.repeat) this.stop();
				this.dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
				if(this.onEnd != null) (this.onEnd)();
			}
		}
		
		protected function gotoFrame(frame : int) : void {
			if(!this.cache) {
			}
			else {
				this.currentFrame = Math.round(frame);
				this.bitmap.bitmapData = this.frames[this.currentFrame - 1];
				this.bitmap.smoothing = true;
			}
		}
		
		public function prevFrame() : void {
			this.currentFrame--;
			if(this.currentFrame < 1) this.currentFrame = this.getTotalFrames();
			this.gotoFrame(this.currentFrame);
		}
		
		public function nextFrame() : void {
			this.currentFrame++;
			if(this.currentFrame > this.getTotalFrames()) this.currentFrame = 1;
			this.gotoFrame(this.currentFrame);
		}
		
		public function gotoAndPlayRandomFrame() : void {
			this.gotoAndPlay(Math.ceil(Math.random() * this.getTotalFrames()));
		}
		
		public function gotoAndPlay(frame : int) : void {
			this.currentFrame = frame;
			this.gotoFrame(this.currentFrame);
			this.play();
		}
		
		public function gotoAndStop(frame : int) : void {
			if(this.treatAsLoopedGraphic) {
				if(frame > this.getTotalFrames()) frame = frame % this.getTotalFrames();
			}
			this.currentFrame = frame;
			this.gotoFrame(this.currentFrame);
			this.stop();
		}
		
		public function stop() : void {
			this._playing = false;
			this.removeEventListener(flash.events.Event.ENTER_FRAME,this.enterFrame);
		}
		
		public function play() : void {
			this._playing = true;
			this.addEventListener(flash.events.Event.ENTER_FRAME,this.enterFrame,false,0,true);
		}
		
		protected function makeAllChildrenGoToFrame(clip : flash.display.MovieClip,frame : int) : void {
			var _g1 : int = 0, _g : int = clip.numChildren;
			while(_g1 < _g) {
				var i : int = _g1++;
				var child : * = clip.getChildAt(i);
				if(Std._is(child,flash.display.MovieClip)) {
					this.makeAllChildrenGoToFrame(child,frame);
					child.gotoAndStop(frame);
				}
			}
		}
		
		public function buildCacheFromClip(clip : flash.display.MovieClip,rectangle : flash.geom.Rectangle = null) : void {
			this.clip = clip;
			var rect : flash.geom.Rectangle;
			var bounds : * = Reflect.field(clip,"e_bounds");
			if(rectangle == null) {
				if(bounds != null) {
					rect = new flash.geom.Rectangle(bounds.x,bounds.y,bounds.width,bounds.height);
					bounds.visible = false;
				}
				else rect = clip.getRect(clip);
			}
			else rect = rectangle;
			{
				var _g1 : int = 1, _g : int = clip.totalFrames + 1;
				while(_g1 < _g) {
					var i : int = _g1++;
					clip.gotoAndStop(i);
					this.makeAllChildrenGoToFrame(clip,i);
					var bitmapData : flash.display.BitmapData = new flash.display.BitmapData(Std._int(rect.width * this.sX),Std._int(rect.height * this.sY),true,0);
					var m : flash.geom.Matrix = new flash.geom.Matrix();
					m.translate(-rect.x,-rect.y);
					m.scale(clip.scaleX * this.sX,clip.scaleY * this.sY);
					bitmapData.draw(clip,m);
					this.frames.push(bitmapData);
				}
			}
			this.bitmap.x = rect.x;
			this.bitmap.y = rect.y;
		}
		
		public function buildCacheFromLibrary(identifier : String,rectangle : flash.geom.Rectangle = null) : void {
			var instance : flash.display.MovieClip = Type.createInstance(Type.resolveClass(identifier),[]);
			this.buildCacheFromClip(instance,rectangle);
		}
		
		public function isPlaying() : Boolean {
			return this._playing;
		}
		
		public function getTotalFrames() : int {
			return this.frames.length;
		}
		
		public var sY : Number;
		public var sX : Number;
		public function get playing() : Boolean { return isPlaying(); }
		protected function set playing( __v : Boolean ) : void { $playing = __v; }
		protected var $playing : Boolean;
		protected var _playing : Boolean;
		public var currentFrame : int;
		public function get totalFrames() : int { return getTotalFrames(); }
		protected function set totalFrames( __v : int ) : void { $totalFrames = __v; }
		protected var $totalFrames : int;
		public var onEnd : Function;
		public var reverse : Boolean;
		public var treatAsLoopedGraphic : Boolean;
		public var repeat : Boolean;
		protected var clipData : flash.display.MovieClip;
		protected var cache : Boolean;
		public var frames : Array;
		public var clip : flash.display.MovieClip;
		public var bitmap : flash.display.Bitmap;
	}
}
