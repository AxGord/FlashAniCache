package touchmypixel.events {
	import flash.events.Event;
	import flash.Boot;
	public class BitmapEvent extends flash.events.Event {
		public function BitmapEvent(type : String = null,bubbles : * = null,cancelable : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(type,bubbles,cancelable);
		}}
		
	}
}
