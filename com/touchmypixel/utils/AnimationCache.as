/*
 * Copyright (c) 2008, TouchMyPixel & contributors
 * Original author : Tony Polinelli <tonyp@touchmypixel.com> 
 * Contributers: Tarwin Stroh-Spijer 
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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	public class AnimationCache extends EventDispatcher
	{
		private var animations:Object = { };
		private var aniscale:Object = { };
		private static var instance:AnimationCache;
		
		public function AnimationCache(lock:AnimationCacheLock) 
		{
			instance = this;
		}	
		
		public static function getInstance():AnimationCache
		{
			return !instance ? new AnimationCache(new AnimationCacheLock()) : instance;
		}
		
		public function cacheAnimation(identifier:String, sX:Number=1, sY:Number=1):Animation
		{
			var animation:Animation
			if (!animations[identifier] || aniscale[identifier].x != sX || aniscale[identifier].y != sY) {
				if (animations[identifier]) delete animations[identifier];
				animation = new Animation(identifier, sX, sY);
				animations[identifier] = animation;
				aniscale[identifier] = { x:sX, y:sY };
			} else {
				animation = animations[identifier]
			}
			return animation;
		}
		
		public function getAnimation(id):Animation
		{
			if (!animations[id]) {
				trace("MISSING ANIMATION :"+ id);
				return null;
			}
			
			return animations[id].copy();
		}
	}
}
internal class AnimationCacheLock{}

