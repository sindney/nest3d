package nest.view.lights 
{
	import flash.geom.Vector3D;
	
	/**
	 * PointLight
	 */
	public class PointLight implements ILight {
		
		private var _color:uint;
		private var _rgba:Vector.<Number>;
		private var _position:Vector.<Number>;
		private var _radius:Vector.<Number>;
		
		public function PointLight(color:uint = 0xffffff, radius:Number = 400, x:Number = 0, y:Number = 0, z:Number = 0) {
			_position = new Vector.<Number>(4, true);
			_position[0] = x;
			_position[1] = y;
			_position[2] = z;
			_position[3] = 1;
			_radius = new Vector.<Number>(4, true);
			_radius[0] = 0;
			_radius[1] = 0;
			_radius[2] = 0;
			_radius[3] = radius;
			_rgba = new Vector.<Number>(4, true);
			this.color = color;
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
		 * radius
		 */
		public function get radius():Vector.<Number> {
			return _radius;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.lights.PointLight]";
		}
		
	}

}