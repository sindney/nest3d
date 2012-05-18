package nest.control.factories
{
	import nest.view.effects.IEffect;
	import nest.view.lights.*;
	import nest.view.Shader3D;
	
	/**
	 * ShaderFactory
	 */
	public class ShaderFactory {
		
		/**
		 * Create necessary data for shader3d object.
		 * @param	shader Target shader.
		 * @param	lights In view.lights.
		 * @param	effect In view.effect.
		 * @param	fog Toggle fog rendering on/off.
		 * @param	kil Toggle agal command kil on/off.
		 */
		public static function create(shader:Shader3D, lights:Vector.<ILight> = null, effect:IEffect = null, fog:Boolean = false, kil:Boolean = false):void {
			// vertex shader
			var vertex:String = "m44 op, va0, vc0\n" + 
								"mov v0, va0\n";
			
			if (shader.uv) vertex += "mov v1, va1\n";
			if (shader.normal) vertex += "mov v2, va2\n";
			
			// fragment shader
			var fragment:String;
			if (lights) {
				fragment = shader.uv ? "tex ft7, v1, fs0 <2d,linear,mipnone>\n" : "mov ft7, fc27\n";
				if (kil) fragment += "sub ft7.w, ft7.w, fc22.w\nkil ft7.w\n";
				
				var j:int = 1;
				var light:ILight;
				for each(light in lights) {
					if (light is AmbientLight) {
						fragment += "mul ft0, ft7, fc0                \n";
					} else if (light is DirectionalLight) {
						// j    : color
						// j + 1: direction
						fragment += "mov ft2, fc" + (j + 1) + "       \n" + 
									"m44 ft2, ft2, fc23               \n" + 
									"nrm ft2.xyz, ft2                 \n" + 
									"dp3 ft1, ft2, v2                 \n" + 
									"sat ft1, ft1                     \n" + 
									"mul ft1, ft1, ft7                \n" + 
									"mul ft1, ft1, fc" + j + "        \n" + 
									"add ft0, ft0, ft1                \n";
						j += 2;
					} else if (light is PointLight) {
						// j    : color
						// j + 1: position
						// j + 2: radius
						fragment += "mov ft2, fc" + (j + 1) + "       \n" + 
									"m44 ft2, ft2, fc23               \n" + 
									"sub ft2, ft2, v0                 \n" + 
									"dp3 ft3, ft2, ft2                \n" + 
									"sqt ft3, ft3                     \n" + 
									"sub ft3, fc" + (j + 2) + ".w, ft3\n" + 
									"div ft3, ft3, fc" + (j + 2) + ".w\n" + 
									"sat ft3, ft3                     \n" + 
									"dp3 ft1, ft2, v2                 \n" + 
									"sat ft1, ft1                     \n" + 
									"mul ft1, ft1, ft7                \n" + 
									"mul ft1, ft1, fc" + j + "        \n" + 
									"mul ft1, ft1, ft3                \n" + 
									"add ft0, ft0, ft1                \n";
						j += 3;
					}
				}
			} else {
				fragment = shader.uv ? "tex ft0, v1, fs0 <2d,linear,mipnone>\n" : "mov ft0, fc27\n";
				if (kil) fragment += "sub ft0.w, ft0.w, fc22.w\nkil ft0.w\n";
			}
			if (effect) fragment += effect.fragment;
			
			if (fog) {
				fragment += "mov ft2,   fc21           \n" + 
							"m44 ft2,   ft2,    fc23   \n" + 
							"sub ft1,   ft2,    v0     \n" + 
							"dp3 ft1.x, ft1,    ft1    \n" + 
							"max ft1.x, ft1.x,  fc19.y \n" + 
							"min ft1.x, ft1.x,  fc19.x \n" + 
							"sub ft1.x, ft1.x,  fc19.y \n" + 
							"mov ft1.y, fc19.y         \n" + 
							"sub ft1.y, fc19.x, ft1.y  \n" + 
							"div ft1.x, ft1.x,  ft1.y  \n" + 
							"sub ft2,   fc20,   ft0    \n" + 
							"mul ft2,   ft1.x,  ft2    \n" + 
							"add ft0,   ft2,    ft0    \n";
			}
			fragment += "mov oc, ft0\n";
			
			shader.setFromString(vertex, fragment);
		}
		
	}

}