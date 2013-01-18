package nest.view.material 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	
	import nest.view.ViewPort;
	
	/**
	 * TextureResource
	 */
	public class TextureResource {
		
		public static function uploadWithMipmaps(texture:TextureBase, bmd:BitmapData, side:int = -1):void {
			var width:int = bmd.width;
			var height:int = bmd.height;
			var leve:int = 0;
			var image:BitmapData = new BitmapData(bmd.width, bmd.height);
			var matrix:Matrix = new Matrix();
			
			while (width > 0 && height > 0) {
				image.draw(bmd, matrix, null, null, null, true);
				if (side == -1) {
					(texture as Texture).uploadFromBitmapData(image, leve);
				} else {
					(texture as CubeTexture).uploadFromBitmapData(image, side, leve);
				}
				matrix.scale(0.5, 0.5);
				leve++;
				width >>= 1;
				height >>= 1;
			}
			image.dispose();
		}
		
		private var _texture:Texture;
		private var _data:BitmapData;
		private var _mipmapping:Boolean = false;
		
		public function TextureResource() {
			
		}
		
		public function dispose():void {
			if (_texture) _texture.dispose();
			if (_data) _data.dispose();
			_texture = null;
			_data = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get data():BitmapData {
			return _data;
		}
		
		public function set data(value:BitmapData):void {
			if (_data != value) {
				if (value) {
					if (!_data || _data.width != value.width || _data.height != value.height) {
						if (_texture)_texture.dispose();
						_texture = ViewPort.context3d.createTexture(value.width, value.height, Context3DTextureFormat.BGRA, false);
						_mipmapping ? uploadWithMipmaps(_texture, value) : _texture.uploadFromBitmapData(value);
					}
				} else {
					if(_texture) _texture.dispose();
					_texture = null;
				}
				_data = value;
			}
		}
		
		public function get mipmapping():Boolean {
			return _mipmapping;
		}
		
		public function set mipmapping(value:Boolean):void {
			if (_mipmapping != value) {
				_mipmapping = value;
				if (_data) _mipmapping ? uploadWithMipmaps(_texture, _data) : _texture.uploadFromBitmapData(_data);
			}
		}
		
		public function get texture():Texture {
			return _texture;
		}
		
		public function set texture(value:Texture):void {
			_texture = value;
		}
		
	}

}