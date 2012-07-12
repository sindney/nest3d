package nest.view.lights 
{
	
	/**
	 * AmbientLight
	 */
	public class AmbientLight implements ILight {
		
		private var _next:ILight;
		
		private var _color:uint;
		private var _rgba:Vector.<Number>;
		
		public function AmbientLight(color:uint = 0x333333) {
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
		
		public function get rgba():Vector.<Number> {
			return _rgba;
		}
		
		public function get next():ILight {
			return _next;
		}
		
		public function set next(value:ILight):void {
			_next = value;
		}
		
	}

}