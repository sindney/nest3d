package nest.view 
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	import nest.control.GlobalMethods;
	import nest.view.lights.*;
	
	/**
	 * Shader3D
	 */
	public class Shader3D {
		
		public static function createLight(light:AmbientLight, specular:Boolean = false, normalmap:Boolean = false):String {
			var fragment:String = "";
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
					} else if (l is PointLight) {
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
					} else if (l is SpotLight) {
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
					l = l.next;
				}
			} else {
				fragment += "mov ft0, ft7\n";
			}
			return fragment;
		}
		
		public static const assembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		public var program:Program3D;
		public var normal:Boolean;
		
		public function Shader3D() {
			program = GlobalMethods.context3d.createProgram();
		}
		
		public function setFromString(vertex:String, fragment:String, normal:Boolean):void {
			Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vertex);
			var vt:ByteArray = Shader3D.assembler.agalcode;
			Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragment);
			var fg:ByteArray = Shader3D.assembler.agalcode;
			program.upload(vt, fg);
			this.normal = normal;
		}
		
	}

}