package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import nest.view.lights.*;
	import nest.view.Shader3D;
	
	/**
	 * MovieMaterial
	 */
	public class MovieMaterial implements IMaterial {
		
		protected var _diffuse:TextureResource;
		protected var _specular:TextureResource;
		
		protected var _vertData:Vector.<Number>;
		protected var _fragData:Vector.<Number>;
		
		protected var _light:AmbientLight;
		protected var _shader:Shader3D;
		
		protected var _frames:Vector.<BitmapData>;
		protected var _frame:int = 0;
		
		public function MovieMaterial(specular:BitmapData = null, glossiness:int = 10) {
			_vertData = new Vector.<Number>(4, true);
			_vertData[0] = _vertData[2] = _vertData[3] = 0;
			_vertData[1] = 1;
			_fragData = new Vector.<Number>(4, true);
			_fragData[0] = glossiness;
			_fragData[1] = 1;
			_shader = new Shader3D();
			_diffuse = new TextureResource();
			_specular = new TextureResource();
			_specular.data = specular;
			_frames = new Vector.<BitmapData>();
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
			if (j == 1) context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 23, _fragData);
		}
		
		public function unload(context3d:Context3D):void {
			context3d.setTextureAt(0, null);
			if (_specular.texture) context3d.setTextureAt(1, null);
		}
		
		public function update():void {
			var normal:Boolean = _light != null;
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
			
			var fragment:String = "tex ft7, v1, fs0 <2d,linear," + (_diffuse.mipmapping ? "miplinear" : "mipnone") + ">\n";
			if (specular) fragment += "tex ft6, v1, fs1 <2d,linear," + (_specular.mipmapping ? "miplinear" : "mipnone") + ">\n";
			fragment += Shader3D.createLight(_light, specular, false);
			fragment += "mov oc, ft0\n";
			
			_shader.setFromString(vertex, fragment, normal);
		}
		
		public function dispose():void {
			_shader.program.dispose();
			_diffuse.dispose();
			_specular.dispose();
			_frames = null;
			_diffuse = null;
			_specular = null;
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
		 * <p>There's 23 empty fc left.</p>
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
		
		public function get shader():Shader3D {
			return _shader;
		}
		
		public function get frames():Vector.<BitmapData> {
			return _frames;
		}
		
		public function set frames(value:Vector.<BitmapData>):void {
			_frames = value;
			if (_frames) _diffuse.data = _frames[frame];
		}
		
		public function get frame():int {
			return _frame;
		}
		
		public function set frame(value:int):void {
			_frame = value;
			_diffuse.data = _frames[frame];
		}
		
	}

}