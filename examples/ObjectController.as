package 
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import nest.object.Object3D;
	
	/**
	 * ObjectController
	 */
	public class ObjectController {
		
		public var target:Object3D;
		public var sensitive:Number = 0.01;
		
		private var stage:Stage;
		
		public function ObjectController(target:Object3D, stage:Stage) {
			this.target = target;
			this.stage = stage;
			mouseEnabled = true;
			if (target.rotation.x > d90) target.rotation.x = d90;
			if (target.rotation.x < -d90) target.rotation.x = -d90;
		}
		
		private var _mouseEnabled:Boolean = false;
		
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(b:Boolean):void {
			var old:Boolean = _mouseEnabled;
			_mouseEnabled = b;
			if (old != b) {
				if (b) {
					stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					moving = false;
				} else {
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					moving = false;
				}
			}
		}
		
		private var oldX:Number;
		private var oldY:Number;
		private var moving:Boolean;
		
		private function onMouseDown(e:MouseEvent):void {
			moving = true;
			oldX = e.stageX;
			oldY = e.stageY;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			moving = false;
		}
		
		private const d90:Number = Math.PI / 2;
		
		private function onMouseMove(e:MouseEvent):void {
			if (moving) {
				target.rotation.y -= (oldX - e.stageX) * sensitive;
				target.rotation.x -= (oldY - e.stageY) * sensitive;
				if (target.rotation.x > d90) target.rotation.x = d90;
				if (target.rotation.x < -d90) target.rotation.x = -d90;
				target.changed = true;
				oldX = e.stageX;
				oldY = e.stageY;
			}
		}
		
	}

}