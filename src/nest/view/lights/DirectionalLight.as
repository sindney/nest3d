package nest.view.lights 
{
	import flash.geom.Vector3D;
	
	/**
	 * DirectionalLight
	 */
	public class DirectionalLight implements ILight {
		
		private var _next:ILight;
		
		private var _color:uint;
		private var _direction:Vector.<Number>;
		private var _rgba:Vector.<Number>;
		
		private var _active:Boolean = true;
		
		public function DirectionalLight(color:uint = 0xffffff, x:Number = 1, y:Number = 0, z:Number = 0) {
			_direction = new Vector.<Number>(4, true);
			_direction[0] = x;
			_direction[1] = y;
			_direction[2] = z;
			_direction[3] = 0;
			_rgba = new Vector.<Number>(4, true);
			this.color = color;
		}
		
		public function normalize():void {
			const length:Number = Math.sqrt(_direction[0] * _direction[0] + _direction[1] * _direction[1] + _direction[2] * _direction[2]);
			_direction[0] = _direction[0] / length;
			_direction[1] = _direction[1] / length;
			_direction[2] = _direction[2] / length;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get direction():Vector.<Number> {
			return _direction;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
			_rgba[0] = ((value >> 16) & 0xFF) / 255;
			_rgba[1] = ((value >> 8) & 0xFF) / 255;
			_rgba[2] = (value & 0xFF) / 255;
			_rgba[3] = 1;
		}
		
		public function get rgba():Vector.<Number> {
			return _rgba;
		}
		
		public function get active():Boolean {
			return _active;
		}
		
		public function set active(value:Boolean):void {
			_active = value;
		}
		
		public function get next():ILight {
			return _next;
		}
		
		public function set next(value:ILight):void {
			_next = value;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.lights.DirectionalLight]";
		}
		
	}

}