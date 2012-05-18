package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	
	/**
	 * TextureMaterial
	 */
	public class TextureMaterial implements IMaterial {
		
		private var _data:BitmapData;
		private var _texture:Texture;
		
		private var _optimizeForRenderToTexture:Boolean = true;
		private var _changed:Boolean = false;
		
		public function TextureMaterial(data:BitmapData) {
			this.data = data;
		}
		
		public function upload(context3D:Context3D):void {
			if (_changed) {
				_changed = false;
				if (_texture) _texture.dispose();
				_texture = context3D.createTexture(_data.width, _data.height, Context3DTextureFormat.BGRA, _optimizeForRenderToTexture);
				_texture.uploadFromBitmapData(_data);
			}
			context3D.setTextureAt(0, _texture);
		}
		
		public function unload(context3D:Context3D):void {
			if (_texture) context3D.setTextureAt(0, null);
		}
		
		public function dispose():void {
			if (_texture) _texture.dispose();
			if (_data) _data.dispose();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get data():BitmapData {
			return _data;
		}
		
		public function set data(value:BitmapData):void {
			if (_data != value) {
				_data = value;
				_changed = true;
			}
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
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.materials.TextureMaterial]";
		}
		
	}

}