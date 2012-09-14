/*
 * Copyright (c) 2008, TouchMyPixel & contributors
 * Original author : Tony Polinelli <tonyp@touchmypixel.com> 
 * Contributers: Tarwin Stroh-Spijer <tarwin@touchmypixel.com> 
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE TOUCH MY PIXEL & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE TOUCH MY PIXEL & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.touchmypixel.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Animation extends Sprite
	{
		public var bitmap:Bitmap;
		public var clip:MovieClip;
		public var frames:Array = [];
		
		public var repeat:Boolean = true;
		public var onEnd:Function;
		public var reverse:Boolean = false;
		public var speed:Number = 1;
		public var treatAsLoopedGraphic:Boolean = false;
		
		public var _playing:Boolean = false;
		private var _cache:Boolean = true;
		private var _totalFrames;
		public var _currentFrame:Number = 1;
		
		private var sX:Number;
		private var sY:Number;
		
		public function Animation(identifier:String=null, sX:Number=1, sY:Number=1) 
		{
			this.sX = sX;
			this.sY = sY;
			bitmap = new Bitmap();
			bitmap.smoothing = false;
			addChild(bitmap);
			
			if (identifier != null)
				buildCache(identifier);
		}
		
		public function set bitmapData(value:BitmapData){ bitmap.bitmapData = value; }
		public function get bitmapData():BitmapData { return bitmap.bitmapData; }
		
		public function get playing():Boolean { return _playing; }
		public function get totalFrames():Number { return clip.totalFrames; }
		public function get currentFrame():Number { return _currentFrame; }
		
		public function buildCache(identifier:String):void
		{
			clip = new (getDefinitionByName(identifier))();
			
			addChild(clip);
			
			var rect:Rectangle;
			
			var bounds = clip["bounds"];
			if (bounds != null)
			{
				rect = bounds.getRect(bounds.parent);
				bounds.visible = false;
			} else {
				rect = clip.getRect(clip);
			}
			
			for (var i = 1; i <= clip.totalFrames; i++)
			{
				clip.gotoAndStop(i);
				makeAllChildrenGoToFrame(clip, i);
				var bitmapData:BitmapData = new BitmapData(rect.width*sX, rect.height*sY, true, 0x00000000);
				var m:Matrix = new Matrix();
				m.translate(-rect.x, -rect.y);
				m.scale(clip.scaleX*sX, clip.scaleY*sY);
				bitmapData.draw(clip,m);
				frames.push(bitmapData);
			}
			bitmap.x = rect.x;
			bitmap.y = rect.y;
			
			removeChild(clip);
		}
		
		private function makeAllChildrenGoToFrame(m:MovieClip, f:int):void
		{
			for (var i:int = 0; i < m.numChildren; i++) {
				var c = m.getChildAt(i);
				if (c is MovieClip) {
					makeAllChildrenGoToFrame(c, f);
					c.gotoAndStop(f);
				}
			}
		}
		
		public function play():void
		{
			_playing = true;
			addEventListener(Event.ENTER_FRAME, enterFrame, false, 0, true);
		}
		
		public function stop():void
		{
			_playing = false;
			removeEventListener(Event.ENTER_FRAME, enterFrame)
		}
		
		public function gotoAndStop(frame:Number):void
		{
			if (treatAsLoopedGraphic) {
				if (frame > totalFrames) {
					frame = frame % totalFrames;
				}
			}
			_currentFrame = frame;
			
			goto(_currentFrame);
			stop();
		}
		
		public function gotoAndPlay(frame:Number):void
		{
			_currentFrame = frame;
			goto(_currentFrame);
			play();
		}
		
		public function gotoAndPlayRandomFrame():void
		{
			gotoAndPlay(Math.ceil(Math.random() * totalFrames));
		}
		
		public function nextFrame(useSpeed:Boolean = false):void
		{
			useSpeed ? _currentFrame += speed : _currentFrame++;
			if (_currentFrame > totalFrames) _currentFrame = 1;
			goto(Math.floor(_currentFrame));
		}
		
		public function prevFrame(useSpeed:Boolean = false):void
		{
			useSpeed ? _currentFrame -= speed : _currentFrame--;
			
			if (_currentFrame < 1) _currentFrame = totalFrames;
			goto(Math.floor(_currentFrame));
		}
		
		private function goto(frame:Number):void
		{
			bitmap.bitmapData = frames[_currentFrame-1];
			bitmap.smoothing = true;
		}
		
		public function enterFrame(e:Event = null):void
		{
			if(reverse){
				prevFrame(true);
			}else {
				nextFrame(true);
			}
			
			if (_currentFrame >= totalFrames) {
				
				if (!repeat) {
					stop();
				}
				dispatchEvent(new Event(Event.COMPLETE));
				if (onEnd != null) onEnd();
			}
		}
		
		public function destroy()
		{
			stop();
			if (parent) parent.removeChild(this);
		}
		
		public function copy()
		{
			var newAnimation = new Animation();
			newAnimation.frames = frames;
			newAnimation.bitmap.x = bitmap.x;
			newAnimation.bitmap.y = bitmap.y;
			newAnimation.clip = clip;
			newAnimation.gotoAndStop(1);
			return newAnimation;
		}
		
	}
}