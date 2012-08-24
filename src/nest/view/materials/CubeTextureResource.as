package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	
	import nest.control.GlobalMethods;
	
	/**
	 * CubeTextureResource
	 */
	public class CubeTextureResource {
		
		private var _texture:CubeTexture;
		private var _data:Vector.<BitmapData>;
		
		public function CubeTextureResource() {
			
		}
		
		public function upload():void {
			if (!_texture) return;
			TextureResource.uploadWithMipmaps(_texture, _data[0], 0);
			TextureResource.uploadWithMipmaps(_texture, _data[1], 1);
			TextureResource.uploadWithMipmaps(_texture, _data[2], 2);
			TextureResource.uploadWithMipmaps(_texture, _data[3], 3);
			TextureResource.uploadWithMipmaps(_texture, _data[4], 4);
			TextureResource.uploadWithMipmaps(_texture, _data[5], 5);
		}
		
		public function dispose():void {
			if (_texture) _texture.dispose();
			if (_data) {
				_data[0].dispose();
				_data[1].dispose();
				_data[2].dispose();
				_data[3].dispose();
				_data[4].dispose();
				_data[5].dispose();
			}
			_texture = null;
			_data = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get data():Vector.<BitmapData> {
			return _data;
		}
		
		public function set data(value:Vector.<BitmapData>):void {
			if (_data != value) {
				_data = value;
				if (value) {
					_texture = GlobalMethods.context3d.createCubeTexture(value[0].width, Context3DTextureFormat.BGRA, false);
					TextureResource.uploadWithMipmaps(_texture, value[0], 0);
					TextureResource.uploadWithMipmaps(_texture, value[1], 1);
					TextureResource.uploadWithMipmaps(_texture, value[2], 2);
					TextureResource.uploadWithMipmaps(_texture, value[3], 3);
					TextureResource.uploadWithMipmaps(_texture, value[4], 4);
					TextureResource.uploadWithMipmaps(_texture, value[5], 5);
				} else {
					if (_texture) _texture.dispose();
					_texture = null;
				}
			}
		}
		
		public function get texture():CubeTexture {
			return _texture;
		}
		
	}

}