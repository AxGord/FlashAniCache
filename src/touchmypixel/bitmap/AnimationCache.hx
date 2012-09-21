package touchmypixel.bitmap;

import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.Lib;
import flash.system.System;
import flash.utils.Dictionary;
import pony.SpeedLimit;
import touchmypixel.bitmap.Animation;
import touchmypixel.events.BitmapEvent;
import touchmypixel.events.ProcessEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.TypedDictionary;

import pony.ArrKey;

class AnimationCache extends EventDispatcher
{
	public static var clearDelay:Int = 200;
	public static var clearMem:Int = 300 * 1024 * 1024;
	
	public var cacheQueue:Array<AnimationCacheQueueItem>;
	public var currentlyProcessingItem:Int;
	public var replaceExisting:Bool;
	
	public var animations:ArrKey<Dynamic, Animation>;
	//public var counters:Hash<Int>;
	
	private static var instance:AnimationCache;
	
	private var sl:SpeedLimit;
	
	public function new() 
	{	
		sl = new SpeedLimit(clearDelay);
		super();
		//if(AnimationCache.instance != null) throw(new Error("AnimationCache is a Singleton. Don't Instantiate!"));
		instance = this;
		
		animations = new ArrKey<Dynamic, Animation>();
		cacheQueue = new Array();
		replaceExisting = false;
	}
	
	public static function getInstance():AnimationCache
	{
		return instance == null ? new AnimationCache() : instance;
	}
	
	public function cacheAnimation(id:String, clip:MovieClip, sX:Float = 1, sY:Float = 1):Animation
	{
		var animation:Animation = null;
		var k:Array<Dynamic> = [id, sX, sY];
		//try {
		if (replaceExisting || !animations.exists(k)) {
			//trace('Create ' + k);
			animation = new Animation(sX, sY);
			animation.buildCacheFromClip(clip);
			animations.set(k, animation);
		} else {
			animation = getAnimation(id, sX, sY);
		}
		//}catch (e:Dynamic) {
			//	dispatchEvent(new BitmapEvent(BitmapEvent.BITMAP_CREATION_FAIL, true, false, "Error caching tiles in AnimationCache::cacheAnimation"));
		//}
		sl.abort();
		sl.run(testMemory);
		return animation;
	}
	
	private function testMemory():Void {
		if (System.totalMemory > clearMem)
			animations.clear();
	}
	
	public function getAnimation(id:String, sX:Float = 1, sY:Float = 1):Animation
	{
		var cachedAnimation = animations.get([id, sX, sY]);
		
		if (cachedAnimation == null) {
			trace("MISSING ANIMATION (AnimationCache): "+ id);
			return null;
		}
		
		var animation:Animation = new Animation();
		animation.frames = cachedAnimation.frames;
		animation.bitmap.x = cachedAnimation.bitmap.x;
		animation.bitmap.y = cachedAnimation.bitmap.y;
		animation.clip = cachedAnimation.clip;
		animation.gotoAndStop(1);	
		return animation;
	}
	
	public function addToCacheQueue(id, clip:MovieClip):Void
	{
		cacheQueue.push( { id:id, clip:clip } );
	}
	
	public function processQueue():Void
	{
		currentlyProcessingItem = 0;
		dispatchEvent(new ProcessEvent(ProcessEvent.START));
		process();
	}
	
	private function process():Void
	{
		trace("process");
		var item = cacheQueue[currentlyProcessingItem++];
		if (item != null)
		{
			cacheAnimation(item.id, item.clip);
			dispatchEvent(new ProcessEvent(ProcessEvent.PROGRESS,currentlyProcessingItem/cacheQueue.length));
			
			// Should be called async' to avoid a hang
			process();
		} else {
			dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE));
			cacheQueue = [];
		}
	}
	
	public function clearAll():Void
	{
		for (v in animations)
			v.destroy();
		animations = new ArrKey<Dynamic, Animation>();
	}
	
}

typedef AnimationCacheQueueItem = {
	var id:String;
	var clip:MovieClip;
}
