package nest.view.material 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import nest.control.factory.ShaderFactory;
	import nest.view.light.*;
	
	/**
	 * EnvMapMaterial
	 */
	public class EnvMapMaterial extends TextureMaterial {
		
		protected var _cubicmap:CubeTextureResource;
		
		public function EnvMapMaterial(cubicmap:Vector.<BitmapData>, reflectivity:Number, diffuse:BitmapData, specular:BitmapData = null, glossiness:int = 10, normalmap:BitmapData = null) {
			super(diffuse, specular, glossiness, normalmap);
			this.reflectivity = reflectivity;
			_cubicmap = new CubeTextureResource();
			_cubicmap.data = cubicmap;
		}
		
		override public function upload(context3d:Context3D):void {
			var i:int, j:int = 1;
			var light:ILight;
			var l:int = _lights.length;
			for (i = 0; i < l; i++) {
				light = _lights[i];
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
			}
			context3d.setTextureAt(0, _diffuse.texture);
			if (_specular.texture) context3d.setTextureAt(1, _specular.texture);
			if (_normalmap.texture) {
				context3d.setTextureAt(2, _normalmap.texture);
				context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, _vertData);
			}
			if (_cubicmap.texture) context3d.setTextureAt(3, _cubicmap.texture);
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 23, _fragData);
		}
		
		override public function unload(context3d:Context3D):void {
			context3d.setTextureAt(0, null);
			if (_specular.texture) context3d.setTextureAt(1, null);
			if (_normalmap.texture) context3d.setTextureAt(2, null);
			if (_cubicmap.texture) context3d.setTextureAt(3, null);
		}
		
		override public function comply(context3d:Context3D):void {
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
								"mov v6, vt7.xyz\n";
			// envmap
			// v5 = I - 2*N*dot(N,I)
			vertex += "sub vt2, va0, vt1\n" + 
						"nrm vt2.xyz, vt2\n" + 
						"dp3 vt3, va2, vt2\n" + 
						"add vt4, va2, va2\n" + 
						"mul vt3, vt3, vt4\n" + 
						"sub vt2, vt2, vt3\n" + 
						"m44 vt2, vt2, vc10\n" + 
						"nrm vt2.xyz, vt2\n" + 
						"mov v5, vt2\n" + 
						"mov v1, va1\n" + 
						"mov v2, va2\n";
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
			if (specular) fragment += "tex ft6, v1, fs1 <2d,linear," + (_specular.mipmapping ? "miplinear" : "mipnone") + ">\n";
			fragment += ShaderFactory.createLight(_lights, specular, normalmap);
			
			fragment += "tex ft1, v5, fs3 <cube,linear,miplinear>\n" + 
						"mul ft1, ft1, fc23.w\n" + 
						"mov ft2, fc23.y\n" + 
						"sub ft2, ft2, fc23.w\n" + 
						"mul ft0, ft0, ft2\n" + 
						"add ft0, ft0, ft1\n" + 
						"sub ft0.w, ft0.w, fc23.z\n" + 
						"kil ft0.w\n" + 
						"mov oc, ft0\n";
			
			if (!_program) _program = context3d.createProgram();
			
			_program.upload(
				ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, vertex), 
				ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, fragment)
			);
		}
		
		override public function dispose():void {
			super.dispose();
			_cubicmap.dispose();
			_cubicmap = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get cubicmap():CubeTextureResource {
			return _cubicmap;
		}
		
		public function get reflectivity():Number {
			return _fragData[3];
		}
		
		public function set reflectivity(value:Number):void {
			_fragData[3] = value;
		}
		
		override public function get normal():Boolean {
			return true;
		}
		
	}

}