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
package ;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.events.MouseEvent;
import pony.SpeedLimit;

import touchmypixel.bitmap.AnimationCache;
import touchmypixel.bitmap.Animation;

/**
 * Container for cached animations
 * @author AxGord
 */
class AniCache extends ExtendedMovieClip
{
	public static var DC:Int = 100;
	
	private var a:Array < { name:String, x:Float, y:Float, clip:Animation, mc:MovieClip } >;
	private var sl:SpeedLimit;
	public var quality:String;
	
	private var lmx:Float;
	private var lmy:Float;
	
	private var prClip:Animation;
	
	public var ac:Bool;
	
	private var n:String;
	private var mc:AniCache;
	
	private var tid:Int;
	

	public function new() 
	{
		ac = true;
		super();
		stop();
		var v:Array<Int> = FLTools.verison;
		if ((v[0] == 11 && v[1] >= 2) || v[0] > 11)
			quality = '16X16';
		else
			quality = "BEST";
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(event:Event):Void {
		if (!ac) return;
		while (numChildren > 0)
			removeChildAt(0);
		sl = new SpeedLimit(200);
		
		var cl:Class<Dynamic> = Type.getClass(this);
		n = Type.getClassName(cl);
		mc = Type.createInstance(cl, []);
		mc.addEventListener(Event.ADDED_TO_STAGE, added);
		mc.ac = false;
		addChild(mc);
		
		
	}
	
	private function added(event:Event):Void {
		var t:DisplayObject = this;
		while (Std.is(t, MovieClip)) {
			t.addEventListener(Event.RESIZE, resize);
			t = t.parent;
		}
		stage.addEventListener(Event.RESIZE, resize);
		stage.addEventListener(FullScreenEvent.FULL_SCREEN, resize);
		resize();
	}
	
	public function resize(event:Event = null):Void {
		sl.abort();
		sl.run(_resize);
	}
	
	private inline function okr(v:Float):Float return Math.ceil(v * DC) / DC
	
	private function _resize():Void {
		var q:String = cast stage.quality;
		stage.quality = cast quality;
		var mx:Float = 1;
		var my:Float = 1;
		var t:DisplayObject = this;
		while (Std.is(t,Sprite)) {
			mx *= t.scaleX;
			my *= t.scaleY;
			t = t.parent;
		}
		if (mx == lmx && my == lmy) return;
		while (numChildren > 0)
			removeChildAt(0);
			
		var animationCache:AnimationCache = AnimationCache.getInstance();
		var clip:Animation = animationCache.cacheAnimation(n, mc, okr(mx), okr(my));
		clip.scaleX = 1 / mx;
		clip.scaleY = 1 / my;
		
		clip.x = 0;
		clip.y = 0;
		if (prClip != null) {
			if (prClip.playing)
				clip.gotoAndPlay(prClip.currentFrame);
			else
				clip.gotoAndStop(prClip.currentFrame);
		} else clip.play();
		
		addChild(prClip = clip);
		
			
		stage.quality = cast q;
	}
	
	override public function stop():Void 
	{
		if (prClip != null)
			prClip.stop();
		else
			super.stop();
	}
	
	override public function play():Void 
	{
		if (prClip != null)
			prClip.play();
	}
	
	override private function _gotoAndPlay(frame:Dynamic, ?scene:String):Void 
	{
		if (!Std.is(frame, Int)) throw 'frame can be only Int type';
		if (prClip != null) {
			var f:Int = cast frame;
			prClip.gotoAndPlay(f);
		}
	}
	
	override private function _gotoAndStop(frame:Dynamic, ?scene:String):Void 
	{
		if (!Std.is(frame, Int)) throw 'frame can be only Int type';
		if (prClip != null) {
			var f:Int = cast frame;
			prClip.gotoAndStop(f);
		}
	}
	
}