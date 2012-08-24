package nest.control.mouse 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.events.MouseEvent;
	
	import nest.control.GlobalMethods;
	import nest.object.IMesh;
	import nest.view.culls.MouseCulling;
	import nest.view.managers.ISceneManager;
	import nest.view.processes.IDProcess;
	import nest.view.processes.IProcess;
	import nest.view.Camera3D;
	
	/**
	 * MouseManager
	 */
	public class MouseManager {
		
		private var _type:String;
		private var _dataProcess:IProcess;
		
		private var culling:MouseCulling;
		private var process:IDProcess;
		
		private var id:uint;
		private var mouseX:Number;
		private var mouseY:Number;
		private var target:IMesh;
		private var map:BitmapData;
		
		public function MouseManager() {
			culling = new MouseCulling();
			process = new IDProcess();
			map = new BitmapData(1, 1, true, 0);
		}
		
		public function init():void {
			GlobalMethods.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.CLICK, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.RIGHT_CLICK, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseEvent);
		}
		
		public function dispose():void {
			GlobalMethods.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.CLICK, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.RIGHT_CLICK, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseEvent);
		}
		
		public function calculate():void {
			var camera:Camera3D = GlobalMethods.camera;
			var context3d:Context3D = GlobalMethods.context3d;
			var manager:ISceneManager = GlobalMethods.manager;
			var width:Number = GlobalMethods.view.width;
			var height:Number = GlobalMethods.view.height;
			
			if (context3d && mouseX <= width && mouseY <= height) {
				var pm:Vector.<Number> = camera.pm.rawData.concat();
				pm[8] = -mouseX * 2 / width;
				pm[9] = mouseY * 2 / height;
				camera.pm.copyRawDataFrom(pm);
				
				context3d.clear(0, 0, 0, 0);
				process.id = 0;
				manager.first = false;
				manager.culling = culling;
				manager.process = process;
				manager.calculate();
				context3d.drawToBitmapData(map);
				context3d.present();
				id = map.getPixel32(0, 0) & 0xffff;
				
				if (id != 0) {
					var mesh:IMesh;
					var event:MouseEvent3D;
					var objects:Vector.<IMesh> = GlobalMethods.manager.objects;
					for each(mesh in objects) {
						if (mesh.id == id) {
							if (target != mesh) {
								if (target) target.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT));
								_type = MouseEvent3D.MOUSE_OVER;
							}
							target = mesh;
						}
					}
					event = new MouseEvent3D(_type);
					if (_dataProcess) {
						context3d.clear(0, 0, 0, 0);
						manager.first = false;
						manager.culling = culling;
						manager.process = _dataProcess;
						manager.calculate();
						context3d.drawToBitmapData(map);
						context3d.present();
						event.data = map.getPixel32(0, 0);
					}
					target.dispatchEvent(event);
				} else {
					if (target) target.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT));
					target = null;
				}
				
				pm[8] = 0;
				pm[9] = 0;
				camera.pm.copyRawDataFrom(pm);
			}
			_type = null;
		}
		
		private function onMouseEvent(e:MouseEvent):void {
			mouseX = GlobalMethods.stage.mouseX;
			mouseY = GlobalMethods.stage.mouseY;
			switch(e.type) {
				case MouseEvent.MOUSE_MOVE:
					_type = MouseEvent3D.MOUSE_MOVE;
					break;
				case MouseEvent.MOUSE_DOWN:
					_type = MouseEvent3D.MOUSE_DOWN;
					break;
				case MouseEvent.CLICK:
					_type = MouseEvent3D.CLICK;
					break;
				case MouseEvent.DOUBLE_CLICK:
					_type = MouseEvent3D.DOUBLE_CLICK;
					break;
				case MouseEvent.RIGHT_CLICK:
					_type = MouseEvent3D.RIGHT_CLICK;
					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:
					_type = MouseEvent3D.RIGHT_MOUSE_DOWN;
					break;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get dataProcess():IProcess {
			return _dataProcess;
		}
		
		public function set dataProcess(value:IProcess):void {
			_dataProcess = value;
		}
		
		public function get type():String {
			return _type;
		}
		
	}

}