package nest.control.factory 
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import nest.view.light.*;
	
	/**
	 * ShaderFactory
	 */
	public final class ShaderFactory {
		
		public static const assembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		public static function createLight(lights:Vector.<ILight>, specular:Boolean = false, normalmap:Boolean = false):String {
			var fragment:String = "";
			var l:int = lights.length;
			if (l > 0) {
				var i:int, j:int = 1;
				var light:ILight;
				if (!normalmap) fragment += "mov ft5, v2\n";
				for (i = 0; i < l; i++) {
					light = lights[i];
					if (light is AmbientLight) {
						fragment += "mul ft0, ft7, fc0\n";
					} else if (light is DirectionalLight) {
						// j    : color
						// j + 1: direction
						fragment += "mov ft2, fc" + (j + 1) + "\n" + 
									"m44 ft2, ft2, fc24\n" + 
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
										"pow ft1, ft1, fc23.x\n" + 
										"mul ft1, ft1, ft4\n" + 
										"sat ft1, ft1\n" + 
										"mul ft1, ft1, ft6\n" + 
										"mul ft1, ft1, fc" + j + "\n" + 
										"add ft0, ft0, ft1\n";
						}
						j += 2;
					} else if (light is PointLight) {
						// j    : color
						// j + 1: position
						// j + 2: radius
						fragment += "mov ft2, fc" + (j + 1) + "\n" + 
									"m44 ft2, ft2, fc24\n" + 
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
										"pow ft1, ft1, fc23.x\n" + 
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
					} else if (light is SpotLight) {
						// j    : color
						// j + 1: position
						// j + 2: direction
						// j + 3: lightParameters
						fragment += "mov ft2, fc" + (j + 1) + "\n" + 
									"m44 ft2, ft2, fc24\n" + 
									"sub ft2, ft2, v0\n" + 
									"dp3 ft1, ft2, ft2\n" + 
									"sqt ft1, ft1\n" + 
									"sub ft1, fc" + (j + 3) + ".w, ft1\n" + 
									"div ft1, ft1, fc" + (j + 3) + ".w\n" + 
									"sat ft4, ft1\n" + 
									"nrm ft2.xyz, ft2\n" + 
									"mov ft1, fc" + (j + 2) + "\n" + 
									"neg ft1, ft1\n" + 
									"m44 ft1, ft1, fc24\n" + 
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
										"pow ft1, ft1, fc23.x\n" + 
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
				}
			} else {
				fragment += "mov ft0, ft7\n";
			}
			return fragment;
		}
		
	}

}