package  {
	import flash.Lib;
	import flash.events.MouseEvent;
	public class Main {
		static protected var m : *;
		static public function main() : void {
			Main.m = flash.Lib.current;
			FLTools.smartFit(Main.m);
			Main.m.bPlay.addEventListener(flash.events.MouseEvent.CLICK,Main.play);
			Main.m.bStop.addEventListener(flash.events.MouseEvent.CLICK,Main.stop);
			Main.m.bResize.addEventListener(flash.events.MouseEvent.CLICK,Main.resize);
			Main.m.bGoto.addEventListener(flash.events.MouseEvent.CLICK,Main.goto);
		}
		
		static protected function play(event : flash.events.MouseEvent) : void {
			Main.m.f.play();
		}
		
		static protected function stop(event : flash.events.MouseEvent) : void {
			Main.m.f.stop();
		}
		
		static protected function resize(event : flash.events.MouseEvent) : void {
			if(Main.m.f.scaleX == 1) {
				Main.m.f.scaleX = 0.5;
				Main.m.f.scaleY = 0.5;
			}
			else {
				Main.m.f.scaleX = 1;
				Main.m.f.scaleY = 1;
			}
		}
		
		static protected function goto(event : flash.events.MouseEvent) : void {
			Main.m.f.gotoAndPlay(1);
		}
		
	}
}
