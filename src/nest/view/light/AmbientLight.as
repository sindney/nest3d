package nest.view.light 
{
	
	/**
	 * AmbientLight
	 */
	public class AmbientLight implements ILight {
		
		private var _castShadows:Boolean = false;
		
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
		
		public function get castShadows():Boolean {
			return _castShadows;
		}
		
		public function set castShadows(value:Boolean):void {
			_castShadows = value;
		}
		
	}

}