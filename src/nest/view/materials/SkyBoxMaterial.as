package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	
	/**
	 * SkyBoxMaterial
	 */
	public class SkyBoxMaterial implements IMaterial {
		
		protected var _cubicmap:CubeTexture;
		protected var _cm_data:Vector.<BitmapData>;
		
		protected var _optimizeForRenderToTexture:Boolean = false;
		protected var _changed:Boolean = true;
		
		public function SkyBoxMaterial(cubicmap:Vector.<BitmapData>) {
			_cm_data = cubicmap;
		}
		
		public function upload(context3D:Context3D):void {
			if (_changed) {
				_changed = false;
				if (_cubicmap) _cubicmap.dispose();
				if (_cm_data[0]) {
					_cubicmap = context3D.createCubeTexture(_cm_data[0].width, Context3DTextureFormat.BGRA, _optimizeForRenderToTexture);
					TextureMaterial.uploadWithMipmaps(_cubicmap, _cm_data[0], 0);
					TextureMaterial.uploadWithMipmaps(_cubicmap, _cm_data[1], 1);
					TextureMaterial.uploadWithMipmaps(_cubicmap, _cm_data[2], 2);
					TextureMaterial.uploadWithMipmaps(_cubicmap, _cm_data[3], 3);
					TextureMaterial.uploadWithMipmaps(_cubicmap, _cm_data[4], 4);
					TextureMaterial.uploadWithMipmaps(_cubicmap, _cm_data[5], 5);
				}
			}
			if (_cm_data[0]) context3D.setTextureAt(0, _cubicmap);
		}
		
		public function unload(context3D:Context3D):void {
			context3D.setTextureAt(0, null);
		}
		
		public function dispose():void {
			if (_cubicmap) _cubicmap.dispose();
			if (_cm_data[0]) {
				_cm_data[0].dispose();
				_cm_data[1].dispose();
				_cm_data[2].dispose();
				_cm_data[3].dispose();
				_cm_data[4].dispose();
				_cm_data[5].dispose();
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function set changed(value:Boolean):void {
			_changed = value;
		}
		
		public function get cubicmap():Vector.<BitmapData> {
			return _cm_data;
		}
		
		public function get uv():Boolean {
			return false;
		}
		
		public function get optimizeForRenderToTexture():Boolean {
			return _optimizeForRenderToTexture;
		}
		
		public function set optimizeForRenderToTexture(value:Boolean):void {
			if (_optimizeForRenderToTexture != value) {
				_optimizeForRenderToTexture = value;
				_changed = true;
			}
		}
		
	}

}