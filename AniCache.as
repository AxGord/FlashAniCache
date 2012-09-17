/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.touchmypixel.utils.Animation;
	import com.touchmypixel.utils.AnimationCache;
	
	/**
	 * Container for cached animations
	 * @author AxGord
	 */
	public class AniCache extends MovieClip {
		private var a:Array = [];
		private var timer:Timer = new Timer(100, 1);
		private var lmx:Number;
		private var lmy:Number;
		
		public function AniCache() {
			stop();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(event:Event):void {
			for (var i:int = 0; i < numChildren; i++) {
				var ob:Object = getChildAt(i);
				if (ob is MovieClip) {
					//trace(ob.scaleY);
					a.push({n:getQualifiedClassName(ob), x:ob.x, y:ob.y, sx:ob.scaleX, sy: ob.scaleY, clip:null});
				}
			}
			
			resize();
			stage.addEventListener(Event.RESIZE, fs);
			timer.addEventListener(TimerEvent.TIMER, resize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, fs);
			//var t:DisplayObject = this;
			//while (t is MovieClip) {
			//	t.addEventListener(Event.RESIZE, resize);
			//	t = t.parent;
			//}
		}
		
		private function fs(event:Event=null):void {
			timer.start();
		}
		
		private function resize(event:Event = null):void {
			var q:String = stage.quality;
			stage.quality = "16X16";
			var mx:Number = 1;
			var my:Number = 1;
			var t:DisplayObject = this;
			while (t is MovieClip) {
				mx *= t.scaleX;
				my *= t.scaleY;
				t = t.parent;
			}
			if (mx == lmx && my == lmy) return;
			while (numChildren > 0)
				removeChildAt(0);
			var s:Number = 2;
			for each (var o:Object in a) {
				//trace(n);
				var animationCache:AnimationCache = AnimationCache.getInstance();
				animationCache.cacheAnimation(o.n, o.sx*mx, o.sy*my);
				var clip:Animation = animationCache.getAnimation(o.n);
				clip.scaleX = 1/mx;
				clip.scaleY = 1/my;
				clip.x = o.x;
				clip.y = o.y;
				if (o.clip != null) {
					if (o.clip.playing)
						clip.gotoAndPlay(o.clip.currentFrame);
					else
						clip.gotoAndStop(o.clip.currentFrame);
					
				} else clip.play();
				addChild(o.clip = clip);
			}
			stage.quality = q;
		}
		
	}
	
}