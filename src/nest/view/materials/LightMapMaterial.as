package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import nest.view.lights.*;
	
	/**
	 * LightMapMaterial
	 */
	public class LightMapMaterial extends TextureMaterial {
		
		protected var _lightmap:TextureResource;
		
		public function LightMapMaterial(lightmap:BitmapData, diffuse:BitmapData, specular:BitmapData = null, glossiness:int = 10, normalmap:BitmapData = null) {
			super(diffuse, specular, glossiness, normalmap);
			_lightmap = new TextureResource();
			_lightmap.data = lightmap;
		}
		
		override public function upload(context3d:Context3D):void {
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
			if (_lightmap.texture) context3d.setTextureAt(3, _lightmap.texture);
			if (j == 1) context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 22, _fragData);
		}
		
		override public function unload(context3d:Context3D):void {
			context3d.setTextureAt(0, null);
			if (_specular.texture) context3d.setTextureAt(1, null);
			if (_normalmap.texture) context3d.setTextureAt(2, null);
			if (_lightmap.texture) context3d.setTextureAt(3, null);
		}
		
		override public function dispose():void {
			super.dispose();
			_lightmap.dispose();
			_lightmap = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get lightmap():TextureResource {
			return _lightmap;
		}
		
	}

}