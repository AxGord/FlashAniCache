package touchmypixel.events;
import flash.events.Event;

/**
 * ...
 * @author GayJam2011
 */

class ProcessEvent extends Event
{
	public static inline var START:String = "start";
	public static inline var PROGRESS:String = "progress";
	public static inline var COMPLETE:String = "complete";

	public var progress:Float;
	
	public function new(type : String, ?_progress : Float = -1, ?bubbles : Bool, ?cancelable : Bool) 
	{
		super(type, bubbles, cancelable);
		progress = _progress;
	}
	
}