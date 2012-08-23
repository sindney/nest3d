package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import nest.view.lights.*;
	
	/**
	 * TextureMaterial
	 */
	public class TextureMaterial implements IMaterial {
		
		protected var _diffuse:TextureResource;
		protected var _specular:TextureResource;
		protected var _normalmap:TextureResource;
		
		protected var _vertData:Vector.<Number>;
		protected var _fragData:Vector.<Number>;
		
		protected var _light:AmbientLight;
		
		public function TextureMaterial(diffuse:BitmapData, specular:BitmapData = null, glossiness:int = 10, normalmap:BitmapData = null) {
			_vertData = new Vector.<Number>(4, true);
			_vertData[0] = _vertData[2] = _vertData[3] = 0;
			_vertData[1] = 1;
			_fragData = new Vector.<Number>(4, true);
			_fragData[0] = glossiness;
			_fragData[1] = 1;
			_diffuse = new TextureResource();
			_diffuse.data = diffuse;
			_specular = new TextureResource();
			_specular.data = specular;
			_normalmap = new TextureResource();
			_normalmap.data = normalmap;
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
			j = 0;
			context3d.setTextureAt(0, _diffuse.texture);
			if (_specular.texture) {
				j = 1;
				context3d.setTextureAt(1, _specular.texture);
			}
			if (_normalmap.texture) {
				j = 1;
				context3d.setTextureAt(2, _normalmap.texture);
				context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, _vertData);
			}
			if (j == 1) context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 22, _fragData);
		}
		
		public function unload(context3d:Context3D):void {
			context3d.setTextureAt(0, null);
			if (_specular.texture) context3d.setTextureAt(1, null);
			if (_normalmap.texture) context3d.setTextureAt(2, null);
		}
		
		public function dispose():void {
			_diffuse.dispose();
			_specular.dispose();
			_normalmap.dispose();
			_diffuse = null;
			_specular = null;
			_normalmap = null;
			_light = null;
			_vertData = null;
			_fragData = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Root light is an AmbientLight.
		 * <p>Link new light source to light.next.</p>
		 * <p>There's 22 empty fc left.</p>
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
		
		public function get glossiness():int {
			return _fragData[0];
		}
		
		public function set glossiness(value:int):void {
			_fragData[0] = value;
		}
		
		public function get uv():Boolean {
			return true;
		}
		
		public function get diffuse():TextureResource {
			return _diffuse;
		}
		
		public function get specular():TextureResource {
			return _specular;
		}
		
		public function get normalmap():TextureResource {
			return _normalmap;
		}
		
	}

}