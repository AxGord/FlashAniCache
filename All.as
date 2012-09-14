package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	/**
	 * Example: resizable DisplayObject
	 * @author AxGord
	 */
	public class All extends MovieClip
	{
		private var beginWidth:Number, beginHeight:Number;
		
		public function All() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			beginWidth = width;
			beginHeight = height;
			stage.addEventListener(Event.RESIZE, resize);
			resize();
		}
		
		
		private function resize(event:Event=null):void {
			x = 0;
			y = 0;
			//Reset to the initial size, so as not to accumulate error
			width = beginWidth;
			height = beginHeight;
			setSize(this, stage.stageWidth, stage.stageHeight);
		}
	}

}