package ;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.Lib;

/**
 * ...
 * @author AxGord
 */

class Main 
{
	private static var m:Dynamic;

	static function main() 
	{
		m = Lib.current;
		FLTools.smartFit(m);
		m.bPlay.addEventListener(MouseEvent.CLICK, play);
		m.bStop.addEventListener(MouseEvent.CLICK, stop);
		m.bResize.addEventListener(MouseEvent.CLICK, resize);
		m.bGoto.addEventListener(MouseEvent.CLICK, goto);
	}
	
	private static function play(event:MouseEvent):Void {
		m.f.play();
	}
	
	private static function stop(event:MouseEvent):Void {
		m.f.stop();
	}
	
	private static function resize(event:MouseEvent):Void {
		if (m.f.scaleX == 1) {
			m.f.scaleX = 0.5;
			m.f.scaleY = 0.5;
		} else {
			m.f.scaleX = 1;
			m.f.scaleY = 1;
		}
	}
	
	private static function goto(event:MouseEvent):Void {
		m.f.gotoAndPlay(1);
	}
	
}