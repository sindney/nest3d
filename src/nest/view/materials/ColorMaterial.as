package nest.view.materials 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	/**
	 * ColorMaterial
	 */
	public class ColorMaterial implements IMaterial {
		
		private var _color:uint;
		private var _rgba:Vector.<Number>;
		
		public function ColorMaterial(color:uint = 0xffffff) {
			_rgba = new Vector.<Number>(4, true);
			this.color = color;
		}
		
		public function upload(context3D:Context3D):void {
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 27, _rgba);
		}
		
		public function unload(context3D:Context3D):void {
			
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
		
		public function get uv():Boolean {
			return false;
		}
		
	}

}