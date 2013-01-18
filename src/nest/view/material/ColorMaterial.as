package nest.view.material 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	
	import nest.control.factory.ShaderFactory;
	import nest.object.IMesh;
	import nest.view.light.*;
	import nest.view.ViewPort;
	
	/**
	 * ColorMaterial
	 */
	public class ColorMaterial implements IMaterial {
		
		protected var _color:uint;
		protected var _rgba:Vector.<Number>;
		
		protected var _lights:Vector.<ILight>;
		
		protected var _program:Program3D;
		
		public function ColorMaterial(color:uint = 0xffffffff) {
			_rgba = new Vector.<Number>(4, true);
			_lights = new Vector.<ILight>();
			_program = ViewPort.context3d.createProgram();
			this.color = color;
		}
		
		public function upload(mesh:IMesh):void {
			var context3d:Context3D = ViewPort.context3d;
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
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 23, _rgba);
		}
		
		public function unload():void {
			
		}
		
		public function comply():void {
			var normal:Boolean = _lights.length > 0;
			var vertex:String = "m44 op, va0, vc0\n" + 
								"mov v0, va0\n" + 
								// cameraPos
								"mov vt0, vc8\n" + 
								// cameraPos to object space
								"m44 vt1, vt0, vc4\n" + 
								// v6 = cameraDir
								"nrm vt7.xyz, vt1\n" + 
								"mov v6, vt7.xyz\n";
			if (normal) vertex += "mov v2, va2\n";
			
			var fragment:String = "mov ft7, fc23\n";
			fragment += ShaderFactory.createLight(_lights);
			fragment += "mov oc, ft0\n";
			
			_program.upload(
				ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, vertex), 
				ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, fragment)
			);
		}
		
		public function dispose():void {
			_program.dispose();
			_lights = null;
			_rgba = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * There's 23 empty fc left.
		 * <p>Ambient light takes 1.</p>
		 * <p>Directional light takes 2.</p>
		 * <p>PointLight light takes 3.</p>
		 * <p>SpotLight light takes 4.</p>
		 */
		public function get lights():Vector.<ILight> {
			return _lights;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
			_rgba[0] = ((value >> 16) & 0xFF) / 255;
			_rgba[1] = ((value >> 8) & 0xFF) / 255;
			_rgba[2] = (value & 0xFF) / 255;
			_rgba[3] = (value >> 24) / 255;
		}
		
		public function get rgba():Vector.<Number> {
			return _rgba;
		}
		
		public function get program():Program3D {
			return _program;
		}
		
		public function get uv():Boolean {
			return false;
		}
		
		public function get normal():Boolean {
			return _lights.length > 0;
		}
		
	}

}