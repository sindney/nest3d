package nest.view.materials 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import nest.view.lights.*;
	
	/**
	 * ColorMaterial
	 */
	public class ColorMaterial implements IMaterial {
		
		protected var _color:uint;
		protected var _rgba:Vector.<Number>;
		
		protected var _light:AmbientLight;
		
		public function ColorMaterial(color:uint = 0xffffff, alpha:Number = 1) {
			_rgba = new Vector.<Number>(4, true);
			this.color = color;
			this.alpha = alpha;
		}
		
		public function upload(context3d:Context3D):void {
			var light:ILight = _light;
			var j:int = 1;
			while (light) {
				if (light is AmbientLight) {
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, light.rgba);
				} else if (light is DirectionalLight) {
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as DirectionalLight).direction);
					j += 2;
				} else if (light is PointLight) {
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as PointLight).position);
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 2, (light as PointLight).radius);
					j += 3;
				} else if (light is SpotLight) {
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as SpotLight).position);
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 2, (light as SpotLight).direction);
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 3, (light as SpotLight).lightParameters);
					j += 4;
				}
				light = light.next;
			}
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 27, _rgba);
		}
		
		public function unload(context3d:Context3D):void {
			
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Root light is an AmbientLight.
		 * <p>Link new light source to light.next.</p>
		 * <p>There's 23 empty fc left.</p>
		 * <p>Ambient light absorbs 1 fc.</p>
		 * <p>Directional light takes 2.</p>
		 * <p>PointLight light takes 3.</p>
		 * <p>SpotLight light takes 4.</p>
		 */
		public function get light():AmbientLight {
			return _light;
		}
		
		public function set light(value:AmbientLight):void {
			_light = value;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
			_rgba[0] = ((value >> 16) & 0xFF) / 255;
			_rgba[1] = ((value >> 8) & 0xFF) / 255;
			_rgba[2] = (value & 0xFF) / 255;
		}
		
		public function get alpha():Number {
			return _rgba[3];
		}
		
		public function set alpha(value:Number):void {
			_rgba[3] = value;
		}
		
		public function get rgba():Vector.<Number> {
			return _rgba;
		}
		
		public function get uv():Boolean {
			return false;
		}
		
	}

}