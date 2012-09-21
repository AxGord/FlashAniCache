package touchmypixel.events {
	import flash.events.Event;
	import flash.Boot;
	public class ProcessEvent extends flash.events.Event {
		public function ProcessEvent(type : String = null,_progress : * = -1,bubbles : * = null,cancelable : * = null) : void { if( !flash.Boot.skip_constructor ) {
			if(_progress==null) _progress=-1;
			super(type,bubbles,cancelable);
			this.progress = _progress;
		}}
		
		public var progress : Number;
		static public var START : String = "start";
		static public var PROGRESS : String = "progress";
		static public var COMPLETE : String = "complete";
	}
}
