package nest.view.lights 
{
	import flash.geom.Vector3D;
	
	/**
	 * SpotLight
	 */
	public class SpotLight implements ILight {
		
		private var _next:ILight;
		
		private var _color:uint;
		private var _rgba:Vector.<Number>;
		private var _position:Vector.<Number>;
		private var _lightParameters:Vector.<Number>;
		private var _direction:Vector.<Number>;
		
		private var _active:Boolean = true;
		
		public function SpotLight(color:uint = 0xffffff, radius:Number = 400, focus:Number = 10, x:Number = 0, y:Number = 0, z:Number = 0, dx:Number = 0, dy:Number = 0, dz:Number = 0) {
			_rgba = new Vector.<Number>(4, true);
			_position = new Vector.<Number>(4, true);
			_position[0] = x;
			_position[1] = y;
			_position[2] = z;
			_position[3] = 1;
			_lightParameters = new Vector.<Number>(4, true);
			_lightParameters[0] = 0;
			_lightParameters[1] = 0;
			_lightParameters[2] = focus;
			_lightParameters[3] = radius;
			_direction = new Vector.<Number>(4, true);
			_direction[0] = dx;
			_direction[1] = dy;
			_direction[2] = dz;
			_direction[3] = 1;
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
		
		/**
		 * r,g,b,a
		 */
		public function get rgba():Vector.<Number> {
			return _rgba;
		}
		
		/**
		 * x,y,z,1
		 */
		public function get position():Vector.<Number> {
			return _position;
		}
		
		/**
		 * 0,0,focus,radius
		 */
		public function get lightParameters():Vector.<Number> {
			return _lightParameters;
		}
		
		/**
		 * Light Direction
		 */
		public function get direction():Vector.<Number> {
			return _direction;
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
			return "[nest.view.lights.SpotLight]";
		}
	}
}