package nest.view.material 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	
	import nest.control.factory.ShaderFactory;
	import nest.view.ViewPort;
	
	/**
	 * SkyBoxMaterial
	 */
	public class SkyBoxMaterial implements IMaterial {
		
		protected var _cubicmap:CubeTextureResource;
		protected var _program:Program3D;
		
		public function SkyBoxMaterial(cubicmap:Vector.<BitmapData>) {
			_cubicmap = new CubeTextureResource();
			_cubicmap.data = cubicmap;
			_program = ViewPort.context3d.createProgram();
		}
		
		public function upload():void {
			ViewPort.context3d.setTextureAt(0, _cubicmap.texture);
		}
		
		public function unload():void {
			ViewPort.context3d.setTextureAt(0, null);
		}
		
		public function comply(context3d:Context3D):void {
			_program.upload(
				ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0\nmov v0, va0\n"), 
				ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, "tex oc, v0, fs0 <cube,linear,miplinear>\n")
			);
		}
		
		public function dispose():void {
			_program.dispose();
			_cubicmap.dispose();
			_cubicmap = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get uv():Boolean {
			return false;
		}
		
		public function get normal():Boolean {
			return false;
		}
		
		public function get cubicmap():CubeTextureResource {
			return _cubicmap;
		}
		
		public function get program():Program3D {
			return _program;
		}
		
	}

}