package nest.control.factories
{
	import nest.view.lights.*;
	import nest.view.Shader3D;
	
	/**
	 * ShaderFactory
	 */
	public class ShaderFactory {
		
		/**
		 * Create necessary data for shader3d object.
		 */
		public static function create(shader:Shader3D, uv:Boolean = true, specular:Boolean = false, mipmapping:Boolean = false, 
										light:AmbientLight = null, normalmap:Boolean = false, lightmap:Boolean = false, 
										fog:Boolean = false, kil:Boolean = false):void {
			const normal:Boolean = light != null;
			
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
			if (uv) vertex += "mov v1, va1\n";
			if (normal) vertex += "mov v2, va2\n";
			if (normalmap) {
				vertex +=  "mov vt0, vc11.x\n" + 
							"mov vt0.z, vc11.w\n" + 
							"crs vt1.xyz, va2, vt0\n" + 
							"mov vt0.z, vc11.x\n" + 
							"mov vt0.y, vc11.w\n" + 
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
							"mov vt6.w, vc11.w\n" + 
							"mov v3, vt6\n";
			}
			
			// fragment shader
			var fragment:String = uv ? "tex ft7, v1, fs0 <2d,linear," + (mipmapping ? "miplinear" : "mipnone") + ">\n" : "mov ft7, fc27\n";
			if (normalmap) {
				fragment += "tex ft5, v1, fs2 <2d,linear," + (mipmapping ? "miplinear" : "mipnone") + ">\n" + 
							"mul ft5, ft5, fc21.y\n" + 
							"sub ft5, ft5, fc21.z\n" + 
							"mul ft0, v4, ft5.x\n" + 
							"mul ft1, v3, ft5.y\n" + 
							"add ft0, ft0, ft1\n" + 
							"mul ft1, v2, ft5.z\n" + 
							"add ft5, ft0, ft1\n";
			}
			if (lightmap) fragment += "tex ft6, v1, fs3 <2d,linear," + (mipmapping ? "miplinear" : "mipnone") + ">\nmul ft7, ft7, ft6\nsat ft7, ft7\n";
			if (specular) fragment += "tex ft6, v1, fs1 <2d,linear," + (mipmapping ? "miplinear" : "mipnone") + ">\n";
			if (kil) fragment += "sub ft7.w, ft7.w, fc22.w\nkil ft7.w\n";
			
			if (light) {
				// ambient
				fragment += "mul ft0, ft7, fc0\n";
				if (!normalmap) fragment += "mov ft5, v2\n";
				
				var j:int = 1;
				var l:ILight = light;
				while (l) {
					if (l is DirectionalLight) {
						if (!l.active) {
							j += 2;
							l = l.next;
							continue;
						}
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
										"pow ft1, ft1, fc21.x\n" + 
										"mul ft1, ft1, ft4\n" + 
										"sat ft1, ft1\n" + 
										"mul ft1, ft1, ft6\n" + 
										"mul ft1, ft1, fc" + j + "\n" + 
										"add ft0, ft0, ft1\n";
						}
						j += 2;
					} else if (l is PointLight) {
						if (!l.active) {
							j += 3;
							l = l.next;
							continue;
						}
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
										"pow ft1, ft1, fc21.x\n" + 
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
						if (!l.active) {
							j += 4;
							l = l.next;
							continue;
						}
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
										"pow ft1, ft1, fc21.x\n" + 
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
			
			if (fog) fragment += "sub ft1, fc20, ft0\nmul ft1, v7.x, ft1\nadd ft0, ft0, ft1\n";
			fragment += "mov oc, ft0\n";
			
			shader.setFromString(vertex, fragment, normal);
		}
		
	}

}