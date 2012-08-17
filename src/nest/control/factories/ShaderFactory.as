package nest.control.factories
{
	import flash.utils.getQualifiedClassName;
	
	import nest.control.GlobalMethods;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	/**
	 * ShaderFactory
	 */
	public class ShaderFactory {
		
		private static const COLOR_MATERIAL:String = "nest.view.materials::ColorMaterial";
		private static const ENVMAP_MATERIAL:String = "nest.view.materials::EnvMapMaterial";
		private static const LIGHTMAP_MATERIAL:String = "nest.view.materials::LightMapMaterial";
		private static const TEXTURE_MATERIAL:String = "nest.view.materials::TextureMaterial";
		
		public static function create(shader:Shader3D, material:IMaterial):void {
			const fog:Boolean = GlobalMethods.view.fog;
			switch(getQualifiedClassName(material)) {
				case COLOR_MATERIAL:
					var color:ColorMaterial = material as ColorMaterial;
					update(shader, color.light, false, false, false, false, false, false, fog);
					break;
				case ENVMAP_MATERIAL:
					var envmap:EnvMapMaterial = material as EnvMapMaterial;
					update(shader, envmap.light, true, envmap.specular != null, envmap.normalmap != null, false, true, envmap.mipmapping, fog);
					break;
				case LIGHTMAP_MATERIAL:
					var lightmap:LightMapMaterial = material as LightMapMaterial;
					update(shader, lightmap.light, true, lightmap.specular != null, lightmap.normalmap != null, true, false, lightmap.mipmapping, fog);
					break;
				case TEXTURE_MATERIAL:
					var texture:TextureMaterial = material as TextureMaterial;
					update(shader, texture.light, true, texture.specular != null, texture.normalmap != null, false, false, texture.mipmapping, fog);
					break;
			}
		}
		
		private static function update(shader:Shader3D, light:AmbientLight = null, uv:Boolean = true, specular:Boolean = false, 
										normalmap:Boolean = false, lightmap:Boolean = false, envmap:Boolean = false,
										mipmapping:Boolean = false, fog:Boolean = false):void {
			const normal:Boolean = (light != null || envmap);
			
			// vertex shader
			var vertex:String = "m44 op, va0, vc0\n" + 
								"mov v0, va0\n" + 
								// cameraPos
								"mov vt0, vc8\n" + 
								// cameraPos to object space
								"m44 vt1, vt0, vc4\n" + 
								// v6 = cameraDir
								"nrm vt7.xyz, vt1\n" + 
								"mov v6, vt7.xyz\n";
			if (fog) {
				vertex += "sub vt1, vt1, va0\n" + 
							"dp3 vt1.x, vt1, vt1\n" + 
							"max vt1.x, vt1.x, vc9.y\n" + 
							"min vt1.x, vt1.x, vc9.x\n" + 
							"sub vt1.x, vt1.x, vc9.y\n" + 
							"mov vt1.y, vc9.y\n" + 
							"sub vt1.y, vc9.x, vt1.y\n" + 
							"div vt1.x, vt1.x, vt1.y\n" + 
							"mov v7, vt1.x\n";
			}
			if (envmap) {
				// v5 = I - 2*N*dot(N,I)
				vertex += "m44 vt1, va2, vc11\n" + 
							"nrm vt1.xyz, vt1\n" + 
							"m44 vt2, va0, vc11\n" + 
							"sub vt2, vt2, vc8\n" + 
							"dp3 vt3, vt1, vt2\n" + 
							"add vt1, vt1, vt1\n" + 
							"mul vt3, vt3, vt1\n" + 
							"sub vt2, vt2, vt3\n" + 
							"nrm vt2.xyz, vt2\n" + 
							"mov v5, vt2\n";
			}
			if (uv) vertex += "mov v1, va1\n";
			if (normal) vertex += "mov v2, va2\n";
			if (normalmap) {
				vertex +=  "mov vt0, vc10.x\n" + 
							"mov vt0.z, vc10.y\n" + 
							"crs vt1.xyz, va2, vt0\n" + 
							"mov vt0.z, vc10.x\n" + 
							"mov vt0.y, vc10.y\n" + 
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
							"mov vt6.w, vc10.y\n" + 
							"mov v3, vt6\n";
			}
			
			// fragment shader
			var fragment:String = uv ? "tex ft7, v1, fs0 <2d,linear," + (mipmapping ? "miplinear" : "mipnone") + ">\n" : "mov ft7, fc27\n";
			if (normalmap) {
				fragment += "tex ft5, v1, fs2 <2d,linear," + (mipmapping ? "miplinear" : "mipnone") + ">\n" + 
							"add ft5, ft5, ft5\n" + 
							"sub ft5, ft5, fc22.y\n" + 
							"mul ft0, v4, ft5.x\n" + 
							"mul ft1, v3, ft5.y\n" + 
							"add ft0, ft0, ft1\n" + 
							"mul ft1, v2, ft5.z\n" + 
							"add ft5, ft0, ft1\n";
			}
			if (lightmap) fragment += "tex ft6, v1, fs3 <2d,linear," + (mipmapping ? "miplinear" : "mipnone") + ">\nmul ft7, ft7, ft6\nsat ft7, ft7\n";
			if (specular) fragment += "tex ft6, v1, fs1 <2d,linear," + (mipmapping ? "miplinear" : "mipnone") + ">\n";
			
			if (light) {
				// ambient
				fragment += "mul ft0, ft7, fc0\n";
				if (!normalmap) fragment += "mov ft5, v2\n";
				
				var j:int = 1;
				var l:ILight = light;
				while (l) {
					if (l is DirectionalLight) {
						// j    : color
						// j + 1: direction
						fragment += "mov ft2, fc" + (j + 1) + "\n" + 
									"m44 ft2, ft2, fc23\n" + 
									"nrm ft2.xyz, ft2\n" + 
									"neg ft2, ft2\n" + 
									"dp3 ft4, ft2, ft5\n" + 
									"sat ft1, ft4\n" + 
									"mul ft1, ft1, ft7\n" + 
									"mul ft1, ft1, fc" + j + "\n" + 
									"add ft0, ft0, ft1\n";
						if (specular) {
							fragment += "add ft1, ft2, v6\n" + 
										"dp3 ft3, ft1, ft1\n" + 
										"sqt ft3, ft3\n" + 
										"div ft1, ft1, ft3\n" + 
										"dp3 ft1, ft1, ft5\n" + 
										"pow ft1, ft1, fc22.x\n" + 
										"mul ft1, ft1, ft4\n" + 
										"sat ft1, ft1\n" + 
										"mul ft1, ft1, ft6\n" + 
										"mul ft1, ft1, fc" + j + "\n" + 
										"add ft0, ft0, ft1\n";
						}
						j += 2;
					} else if (l is PointLight) {
						// j    : color
						// j + 1: position
						// j + 2: radius
						fragment += "mov ft2, fc" + (j + 1) + "\n" + 
									"m44 ft2, ft2, fc23\n" + 
									"sub ft2, ft2, v0\n" + 
									"dp3 ft1, ft2, ft2\n" + 
									"sqt ft1, ft1\n" + 
									"sub ft1, fc" + (j + 2) + ".w, ft1\n" + 
									"div ft1, ft1, fc" + (j + 2) + ".w\n" + 
									"sat ft4, ft1\n" + 
									"nrm ft2.xyz, ft2\n" + 
									"dp3 ft3, ft2, ft5\n" + 
									"sat ft3, ft3\n" + 
									"mul ft1, ft3, ft7\n" + 
									"mul ft1, ft1, fc" + j + "\n" + 
									"mul ft1, ft1, ft4\n" + 
									"add ft0, ft0, ft1\n";
						if (specular) {
							fragment += "add ft1, ft2, v6\n" + 
										"dp3 ft3, ft1, ft1\n" + 
										"sqt ft3, ft3\n" + 
										"div ft1, ft1, ft3\n" + 
										"dp3 ft1, ft1, ft5\n" + 
										"pow ft1, ft1, fc22.x\n" + 
										"dp3 ft3, ft2, ft5\n" + 
										"sat ft3, ft3\n" + 
										"mul ft1, ft1, ft3\n" + 
										"mul ft1, ft1, ft4\n" + 
										"mul ft1, ft1, ft6\n" + 
										"mul ft1, ft1, fc" + j + "\n" + 
										"sat ft1, ft1\n" + 
										"add ft0, ft0, ft1\n";
						}
						j += 3;
					} else if (l is SpotLight) {
						// j    : color
						// j + 1: position
						// j + 2: direction
						// j + 3: lightParameters
						fragment += "mov ft2, fc" + (j + 1) + "\n" + 
									"m44 ft2, ft2, fc23\n" + 
									"sub ft2, ft2, v0\n" + 
									"dp3 ft1, ft2, ft2\n" + 
									"sqt ft1, ft1\n" + 
									"sub ft1, fc" + (j + 3) + ".w, ft1\n" + 
									"div ft1, ft1, fc" + (j + 3) + ".w\n" + 
									"sat ft4, ft1\n" + 
									"nrm ft2.xyz, ft2\n" + 
									"mov ft1, fc" + (j + 2) + "\n" + 
									"neg ft1, ft1\n" + 
									"m44 ft1, ft1, fc23\n" + 
									"nrm ft1.xyz, ft1\n" + 
									"dp3 ft1, ft1, ft2\n" + 
									"max ft1, ft1, fc" + (j + 3) + ".y\n" + 
									"pow ft1, ft1, fc" + (j + 3) + ".z\n" + 
									"mul ft4, ft4, ft1\n" + 
									"dp3 ft3, ft2, ft5\n" + 
									"sat ft3, ft3\n" + 
									"mul ft1, ft3, ft7\n" + 
									"mul ft1, ft1, fc" + j + "\n" + 
									"mul ft1, ft1, ft4\n" + 
									"add ft0, ft0, ft1\n";
						if (specular) {
							fragment += "add ft1, ft2, v6\n" + 
										"dp3 ft3, ft1, ft1\n" + 
										"sqt ft3, ft3\n" + 
										"div ft1, ft1, ft3\n" + 
										"dp3 ft1, ft1, ft5\n" + 
										"pow ft1, ft1, fc22.x\n" + 
										"dp3 ft3, ft2, ft5\n" + 
										"sat ft3, ft3\n" + 
										"mul ft1, ft1, ft3\n" + 
										"mul ft1, ft1, ft4\n" + 
										"mul ft1, ft1, ft6\n" + 
										"mul ft1, ft1, fc" + j + "\n" + 
										"sat ft1, ft1\n" + 
										"add ft0, ft0, ft1\n";
						}
						j += 4;
					}
					l = l.next;
				}
			} else {
				fragment += "mov ft0, ft7\n";
			}
			
			if (envmap) {
				fragment += "tex ft1, v5, fs3 <cube,linear,miplinear>\n" + 
							"mul ft1, ft1, fc22.z\n" + 
							"mul ft0, ft0, fc22.w\n" + 
							"add ft0, ft0, ft1\n";
			}
			
			if (fog) fragment += "sub ft1, fc21, ft0\nmul ft1, v7.x, ft1\nadd ft0, ft0, ft1\n";
			fragment += "mov oc, ft0\n";
			
			shader.setFromString(vertex, fragment, normal);
		}
		
	}

}