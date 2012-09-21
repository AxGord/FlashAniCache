package  {
	import pony.ArrayExtensions;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.display.DisplayObject;
	public class FLTools {
		static public function get os() : String { return getOs(); }
		protected function set os( __v : String ) : void { $os = __v; }
		static protected var $os : String;
		static public function get verison() : Array { return getVersion(); }
		protected function set verison( __v : Array ) : void { $verison = __v; }
		static protected var $verison : Array;
		static public function getOs() : String {
			return flash.system.Capabilities.version.split(" ")[0];
		}
		
		static public function getVersion() : Array {
			return pony.ArrayExtensions.map(flash.system.Capabilities.version.split(" ")[1].split(","),Std._parseInt);
		}
		
		static public function getRect(o : flash.display.DisplayObject) : flash.geom.Rectangle {
			return new flash.geom.Rectangle(o.x,o.y,o.width,o.height);
		}
		
		static public function setRectP(o : flash.display.DisplayObject,r : flash.geom.Rectangle) : void {
			o.x = r.x;
			o.y = r.y;
			FLTools.setSize(o,r.width,r.height);
		}
		
		static public function setSize(o : flash.display.DisplayObject,w : Number,h : Number) : void {
			var d1 : Number = w / h;
			var d2 : Number = o.width / o.height;
			if(d1 < d2) {
				o.width = w;
				o.scaleY = o.scaleX;
				o.y += (h - o.height) / 2;
			}
			else if(d1 > d2) {
				o.height = h;
				o.scaleX = o.scaleY;
				o.x += (w - o.width) / 2;
			}
			else {
				o.width = w;
				o.height = h;
			}
		}
		
		static public function setRect(o : flash.display.DisplayObject,rect : flash.geom.Rectangle) : void {
			o.x = rect.x;
			o.y = rect.y;
			o.width = rect.width;
			o.height = rect.height;
		}
		
		static protected var _rect : flash.geom.Rectangle;
		static protected var _target : flash.display.MovieClip;
		static public function smartFit(m : flash.display.MovieClip) : void {
			FLTools._target = m;
			m.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			m.stage.align = flash.display.StageAlign.TOP_LEFT;
			FLTools._rect = m.getRect(m.stage);
			FLTools.updateSize();
			m.stage.addEventListener(flash.events.Event.RESIZE,FLTools.updateSize);
		}
		
		static public function updateSize(event : flash.events.Event = null) : void {
			var chs : Array = [];
			var zr : flash.geom.Rectangle = new flash.geom.Rectangle();
			{
				var _g1 : int = 0, _g : int = FLTools._target.numChildren;
				while(_g1 < _g) {
					var i : int = _g1++;
					var ch : flash.display.DisplayObject = FLTools._target.getChildAt(i);
					chs.push(FLTools.getRect(ch));
					if(ch.name != "bounds") FLTools.setRect(ch,zr);
				}
			}
			FLTools.setRectP(FLTools._target,new flash.geom.Rectangle(0,0,FLTools._target.stage.stageWidth,FLTools._target.stage.stageHeight));
			{
				var _g11 : int = 0, _g2 : int = FLTools._target.numChildren;
				while(_g11 < _g2) {
					var i1 : int = _g11++;
					var ch1 : flash.display.DisplayObject = FLTools._target.getChildAt(i1);
					if(ch1.name != "bounds") FLTools.setRect(ch1,chs[i1]);
				}
			}
		}
		
	}
}
