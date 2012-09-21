/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package ;
import flash.display.MovieClip;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.display.DisplayObject;
import flash.display.StageScaleMode;
import flash.display.StageAlign;

using pony.Ultra;
/**
 * Flash tools
 * @author AxGord
 */

class FLTools 
{
	static public var os(getOs, null):String;
	static public var verison(getVersion, null):Array<Int>;
	
	static private function getOs():String return Capabilities.version.split(' ')[0]
	static private function getVersion():Array<Int> return Capabilities.version.split(' ')[1].split(',').map(Std.parseInt)
	
	public static function getRect(o:DisplayObject):Rectangle {
		return new Rectangle(o.x, o.y, o.width, o.height);
	}
	
	public static function setRectP(o:DisplayObject, r:Rectangle):Void {
		o.x = r.x;
		o.y = r.y;
		setSize(o, r.width, r.height);
	}
	
	//Вписывает объект внутрь прямоугольника, сохраняя пропорции. Размещает по центру.
	public static function setSize(o:DisplayObject, w:Float, h:Float):Void {
		var d1:Float = w/h;
		var d2:Float = o.width/o.height;
		if (d1 < d2) {
			//height *= w/width;
			o.width = w;
			o.scaleY = o.scaleX;
			o.y += (h - o.height) / 2;
		} else if (d1 > d2) {
			//width *= h/height;
			o.height = h;
			o.scaleX = o.scaleY;
			o.x += (w - o.width) / 2; 
		} else {
			o.width = w;
			o.height = h;
		}
	}
	
	public static function setRect(o:DisplayObject, rect:Rectangle):Void {
		o.x = rect.x;
		o.y = rect.y;
		o.width = rect.width;
		o.height = rect.height;
	}
	
	//SmartFit
	private static var _rect:Rectangle;
	private static var _target:MovieClip;
	
	public static function smartFit(m:MovieClip):Void {
		_target = m;
		m.stage.scaleMode = StageScaleMode.NO_SCALE;
		m.stage.align = StageAlign.TOP_LEFT;
		_rect = m.getRect(m.stage);
		updateSize();
		m.stage.addEventListener(Event.RESIZE, updateSize);
	}
	
	public static function updateSize(event:Event = null):Void {
		var chs:Array<Rectangle> = [];
		var zr:Rectangle = new Rectangle();
		for (i in 0..._target.numChildren) {
			var ch:DisplayObject = _target.getChildAt(i);
			chs.push(getRect(ch));
			if (ch.name != 'bounds')
				setRect(ch, zr);
		}
		
		setRectP(_target, new Rectangle(0, 0, _target.stage.stageWidth, _target.stage.stageHeight));
			
		for (i in 0..._target.numChildren) {
			var ch:DisplayObject = _target.getChildAt(i);
			if (ch.name != 'bounds')
				setRect(ch, chs[i]);
		}
	}
	
}