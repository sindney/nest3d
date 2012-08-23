package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	/**
	 * SkyBoxMaterial
	 */
	public class SkyBoxMaterial implements IMaterial {
		
		protected var _cubicmap:CubeTextureResource;
		
		public function SkyBoxMaterial(cubicmap:Vector.<BitmapData>) {
			_cubicmap = new CubeTextureResource();
			_cubicmap.data = cubicmap;
		}
		
		public function upload(context3d:Context3D):void {
			context3d.setTextureAt(0, _cubicmap.texture);
		}
		
		public function unload(context3d:Context3D):void {
			context3d.setTextureAt(0, null);
		}
		
		public function dispose():void {
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
		
	}

}