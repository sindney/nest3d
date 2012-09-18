package nest.control.controller 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import nest.control.EngineBase;
	import nest.view.Camera3D;
	
	/**
	 * CameraController
	 */
	public class BasicController {
		
		protected const d90:Number = Math.PI / 2;
		
		protected var oldX:Number;
		protected var oldY:Number;
		protected var moving:Boolean;
		
		protected var _mouseEnabled:Boolean = false;
		protected var _keyboardEnabled:Boolean = false;
		protected var _keys:Array = new Array();
		
		public var speed:Number = 1;
		public var sensitive:Number = 0.01;
		
		public function BasicController() {
			
		}
		
		public function update():void {
			var camera:Camera3D = EngineBase.camera;
			var p:Vector3D;
			if (_keyboardEnabled && camera) {
				if (_keys[87]) {
					p = Vector3D.Z_AXIS.clone();
					p.scaleBy(speed);
				}
				if (_keys[83]) {
					p = Vector3D.Z_AXIS.clone();
					p.scaleBy( -speed);
				}
				if (_keys[68]) {
					p = Vector3D.X_AXIS.clone();
					p.scaleBy(speed);
				}
				if (_keys[65]) {
					p = Vector3D.X_AXIS.clone();
					p.scaleBy( -speed);
				}
				if (p) {
					camera.position.copyFrom(camera.matrix.transformVector(p));
					camera.recompose();
				}
			}
		}
		
		protected function onMouseDown(e:MouseEvent):void {
			moving = true;
			oldX = e.stageX;
			oldY = e.stageY;
		}
		
		protected function onMouseUp(e:MouseEvent):void {
			moving = false;
		}
		
		protected function onMouseMove(e:MouseEvent):void {
			var camera:Camera3D = EngineBase.camera;
			if (moving && camera) {
				camera.rotation.y -= (oldX - e.stageX) * sensitive;
				camera.rotation.x -= (oldY - e.stageY) * sensitive;
				if (camera.rotation.x > d90) camera.rotation.x = d90;
				if (camera.rotation.x < -d90) camera.rotation.x = -d90;
				camera.recompose();
				oldX = e.stageX;
				oldY = e.stageY;
			}
		}
		
		protected function onMouseWheel(e:MouseEvent):void {
			var camera:Camera3D = EngineBase.camera;
			var p:Vector3D;
			if (camera) {
				p = Vector3D.Z_AXIS.clone();
				p.scaleBy(e.delta * speed);
				camera.position.copyFrom(camera.matrix.transformVector(p));
				camera.recompose();
			}
		}
		
		protected function onKeyDown(e:KeyboardEvent):void {
			_keys[e.keyCode] = true;
		}
		
		protected function onKeyUp(e:KeyboardEvent):void {
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
					EngineBase.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					EngineBase.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					EngineBase.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					EngineBase.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
					moving = false;
				} else {
					EngineBase.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					EngineBase.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					EngineBase.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					EngineBase.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
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
					EngineBase.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
					EngineBase.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				} else {
					EngineBase.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
					EngineBase.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				}
			}
		}
		
		public function get keys():Array {
			return _keys;
		}
		
	}

}