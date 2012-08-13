package nest.control 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import nest.control.GlobalMethods;
	import nest.view.Camera3D;
	
	/**
	 * CameraController
	 */
	public class CameraController {
		
		private const d90:Number = Math.PI / 2;
		
		private var oldX:Number;
		private var oldY:Number;
		private var moving:Boolean;
		
		private var _mouseEnabled:Boolean = false;
		private var _keyboardEnabled:Boolean = false;
		private var _keys:Array = new Array();
		
		public var speed:Number = 1;
		public var sensitive:Number = 0.01;
		
		public function CameraController() {
			
		}
		
		public function update():void {
			var camera:Camera3D = GlobalMethods.camera;
			if (_keyboardEnabled && camera) {
				if (_keys[87]) camera.translate(Vector3D.Z_AXIS, speed);
				if (_keys[83]) camera.translate(Vector3D.Z_AXIS, -speed);
				if (_keys[68]) camera.translate(Vector3D.X_AXIS, speed);
				if (_keys[65]) camera.translate(Vector3D.X_AXIS, -speed);
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			moving = true;
			oldX = e.stageX;
			oldY = e.stageY;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			moving = false;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			var camera:Camera3D = GlobalMethods.camera;
			if (moving && camera) {
				camera.rotation.y -= (oldX - e.stageX) * sensitive;
				camera.rotation.x -= (oldY - e.stageY) * sensitive;
				if (camera.rotation.x > d90) camera.rotation.x = d90;
				if (camera.rotation.x < -d90) camera.rotation.x = -d90;
				camera.changed = true;
				oldX = e.stageX;
				oldY = e.stageY;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			_keys[e.keyCode] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			_keys[e.keyCode] = false;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void {
			if (_mouseEnabled != value) {
				_mouseEnabled = value;
				if (_mouseEnabled) {
					GlobalMethods.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					GlobalMethods.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					GlobalMethods.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					moving = false;
				} else {
					GlobalMethods.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					GlobalMethods.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					GlobalMethods.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					moving = false;
				}
			}
		}
		
		public function get keyboardEnabled():Boolean {
			return _keyboardEnabled;
		}
		
		public function set keyboardEnabled(value:Boolean):void {
			if (_keyboardEnabled != value) {
				_keyboardEnabled = value;
				if (_keyboardEnabled) {
					GlobalMethods.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
					GlobalMethods.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				} else {
					GlobalMethods.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
					GlobalMethods.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				}
			}
		}
		
		public function get keys():Array {
			return _keys;
		}
		
	}

}