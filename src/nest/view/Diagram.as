package nest.view 
{
	import flash.display.Sprite;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * Diagram
	 */
	public class Diagram extends Sprite {
		
		private const mem:Number = 0.000000954;
		
		private var _info:TextField;
		private var _msg:TextField;
		private var _last:uint = getTimer();
		private var _ticks:int = 0;
		
		public function Diagram() {
			graphics.beginFill(0x666666, 0.8);
			graphics.drawRect(5, 5, 140, 75);
			graphics.endFill();
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(10, 20, 130, 55);
			graphics.endFill();
			
			_info = new TextField();
			_info.defaultTextFormat = new TextFormat("verdana", 10, 0xCCCCCC);
			_info.selectable = false;
			_info.autoSize = "left";
			_info.x = 10;
			_info.y = 5;
			addChild(_info);
			
			_msg = new TextField();
			_msg.defaultTextFormat = new TextFormat("verdana", 10, 0x999999);
			_msg.type = "input";
			_msg.multiline = true;
			_msg.wordWrap = true;
			_msg.selectable = true;
			_msg.width = 130;
			_msg.height = 55;
			_msg.x = 10;
			_msg.y = 20;
			addChild(_msg);
		}
		
		public function update():void {
			_ticks++;
			const now:uint = getTimer();
			const delta:uint = now - _last;
			if (delta >= 500) {
				_info.text = "F " + (_ticks / delta * 1000).toFixed(2) + " M " + (System.totalMemory * mem).toFixed(2);
				_ticks = 0;
				_last = now;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get message():String {
			return _msg.text;
		}
		
		public function set message(value:String):void {
			_msg.text = value;
		}
		
	}

}