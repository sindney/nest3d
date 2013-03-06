package nest.view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import nest.view.process.IContainerProcess;
	import nest.view.process.IRenderProcess;
	
	/**
	 * Diagram
	 */
	public class Diagram extends Sprite {
		
		private var mem:Number = 0.000000954;
		private var flag:Boolean = true;
		
		private var background:Sprite;
		private var info:TextField;
		private var last:uint = getTimer();
		private var ticks:int = 0;
		
		private var _message:TextField;
		
		public function Diagram() {
			background = new Sprite();
			background.graphics.beginFill(0x333333, 1);
			background.graphics.drawRect(5, 5, 80, 65);
			background.graphics.endFill();
			addChild(background);
			
			info = new TextField();
			info.defaultTextFormat = new TextFormat("verdana", 8, 0xCCCCCC);
			info.selectable = false;
			info.autoSize = "left";
			info.x = 5;
			info.y = 5;
			info.mouseEnabled = false;
			addChild(info);
			
			_message = new TextField();
			_message.defaultTextFormat = new TextFormat("verdana", 9, 0xCCCCCC);
			_message.type = "input";
			_message.multiline = true;
			_message.wordWrap = true;
			_message.selectable = true;
			_message.background = true;
			_message.backgroundColor = 0x222222;
			_message.height = 65;
			_message.x = 85;
			_message.y = 5;
			
			onMouseClick();
			background.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function update(processes:Vector.<IRenderProcess>):void {
			ticks++;
			var containerProcess:IContainerProcess;
			var a:int = 0, b:int = 0, c:int = 0, d:int = 0;
			for each(var process:IRenderProcess in processes) {
				if (process is IContainerProcess) {
					containerProcess = process as IContainerProcess;
					a += containerProcess.container.numChildren;
					b += containerProcess.numObjects;
					c += containerProcess.numTriangles;
					d += containerProcess.numVertices;
				}
			}
			var now:uint = getTimer();
			var delta:uint = now - last;
			if (delta >= 500) {
				info.text = "FPS: " + (ticks / delta * 1000).toFixed(2) + "\nMEM: " + (System.totalMemory * mem).toFixed(2);
				info.appendText("\nTOTAL: " + a + "\nNOW: " + b + "\nTRIS: " + c + "\nVTS: " + d);
				ticks = 0;
				last = now;
			}
		}
		
		private function onMouseClick(e:MouseEvent = null):void {
			flag = !flag;
			if (flag) {
				_message.width = stage.stageWidth - 90;
				if (!_message.parent) addChild(_message);
			} else if (_message.parent) removeChild(_message);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get message():TextField {
			return _message;
		}
		
	}

}