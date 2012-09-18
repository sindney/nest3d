package nest.view.material 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import nest.view.light.*;
	import nest.view.Shader3D;
	
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
			context3d.setTextureAt(0, _diffuse.texture);
			if (_specular.texture) context3d.setTextureAt(1, _specular.texture);
			if (_normalmap.texture) {
				context3d.setTextureAt(2, _normalmap.texture);
				context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, _vertData);
			}
			if (_lightmap.texture) context3d.setTextureAt(3, _lightmap.texture);
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 23, _fragData);
		}
		
		override public function unload(context3d:Context3D):void {
			context3d.setTextureAt(0, null);
			if (_specular.texture) context3d.setTextureAt(1, null);
			if (_normalmap.texture) context3d.setTextureAt(2, null);
			if (_lightmap.texture) context3d.setTextureAt(3, null);
		}
		
		override public function update():void {
			var normal:Boolean = _light != null;
			var normalmap:Boolean = _normalmap.texture != null;
			var specular:Boolean = specular.texture != null;
			var vertex:String = "m44 op, va0, vc0\n" + 
								"mov v0, va0\n" + 
								// cameraPos
								"mov vt0, vc8\n" + 
								// cameraPos to object space
								"m44 vt1, vt0, vc4\n" + 
								// v6 = cameraDir
								"nrm vt7.xyz, vt1\n" + 
								"mov v6, vt7.xyz\n" + 
								"mov v1, va1\n";
			if (normal) vertex += "mov v2, va2\n";
			if (normalmap) {
				vertex +=  "mov vt0, vc9.x\n" + 
							"mov vt0.z, vc9.y\n" + 
							"crs vt1.xyz, va2, vt0\n" + 
							"mov vt0.z, vc9.x\n" + 
							"mov vt0.y, vc9.y\n" + 
							"crs vt0.xyz, va2, vt0\n" + 
							// vt0 = (vt1.length > vt0.length ? vt1 : vt0);
							"dp3 vt3, vt1, vt1\n" + 
							"dp3 vt4, vt0, vt0\n" + 
							"slt vt5, vt4, vt3\n" + 
							"mul vt1, vt1, vt5\n" + 
							"slt vt5, vt3, vt4\n" + 
							"mul vt0, vt0, vt5\n" + 
							"add vt0, vt0, vt1\n" + 
							// vt5, v4 = tangent
							"nrm vt5.xyz, vt0\n" + 
							"mov v4, vt5\n" + 
							// vt6, v3 = binormal
							"crs vt6.xyz, va2, vt0\n" + 
							"mov vt6.w, vc9.y\n" + 
							"mov v3, vt6\n";
			}
			
			var fragment:String = "tex ft7, v1, fs0 <2d,linear," + (_diffuse.mipmapping ? "miplinear" : "mipnone") + ">\n";
			if (normalmap) {
				fragment += "tex ft5, v1, fs2 <2d,linear," + (_normalmap.mipmapping ? "miplinear" : "mipnone") + ">\n" + 
							"add ft5, ft5, ft5\n" + 
							"sub ft5, ft5, fc23.y\n" + 
							"mul ft0, v4, ft5.x\n" + 
							"mul ft1, v3, ft5.y\n" + 
							"add ft0, ft0, ft1\n" + 
							"mul ft1, v2, ft5.z\n" + 
							"add ft5, ft0, ft1\n";
			}
			fragment += "tex ft6, v1, fs3 <2d,linear," + (_lightmap.mipmapping ? "miplinear" : "mipnone") + ">\nmul ft7, ft7, ft6\nsat ft7, ft7\n";
			if (specular) fragment += "tex ft6, v1, fs1 <2d,linear," + (_specular.mipmapping ? "miplinear" : "mipnone") + ">\n";
			fragment += Shader3D.createLight(_light, specular, normalmap);
			fragment += "sub ft0.w, ft0.w, fc23.z\nkil ft0.w\n";
			fragment += "mov oc, ft0\n";
			
			_shader.setFromString(vertex, fragment, normal);
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