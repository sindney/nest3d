package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import nest.view.Shader3D;
	
	/**
	 * SkyBoxMaterial
	 */
	public class SkyBoxMaterial implements IMaterial {
		
		protected var _cubicmap:CubeTextureResource;
		protected var _shader:Shader3D;
		
		public function SkyBoxMaterial(cubicmap:Vector.<BitmapData>) {
			_cubicmap = new CubeTextureResource();
			_cubicmap.data = cubicmap;
			_shader = new Shader3D();
		}
		
		public function upload(context3d:Context3D):void {
			context3d.setTextureAt(0, _cubicmap.texture);
		}
		
		public function unload(context3d:Context3D):void {
			context3d.setTextureAt(0, null);
		}
		
		public function update():void {
			_shader.setFromString("m44 op, va0, vc0\nmov v0, va0\n", 
								"tex oc, v0, fs0 <cube,linear,miplinear>\n", false);
		}
		
		public function dispose():void {
			_shader.program.dispose();
			_cubicmap.dispose();
			_cubicmap = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get uv():Boolean {
			return false;
		}
		
		public function get cubicmap():CubeTextureResource {
			return _cubicmap;
		}
		
		public function get shader():Shader3D {
			return _shader;
		}
		
	}

}