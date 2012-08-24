package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	
	import nest.control.GlobalMethods;
	
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
		
		/**
		 * Call this when you redraw your data but didn't change it's size.
		 */
		public function upload():void {
			if (!_texture) return;
			_mipmapping ? uploadWithMipmaps(_texture, _data) : _texture.uploadFromBitmapData(_data);
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
				_data = value;
				if (value) {
					_texture = GlobalMethods.context3d.createTexture(value.width, value.height, Context3DTextureFormat.BGRA, false);
					_mipmapping ? uploadWithMipmaps(_texture, value) : _texture.uploadFromBitmapData(value);
				} else {
					if(_texture) _texture.dispose();
					_texture = null;
				}
			}
		}
		
		public function get mipmapping():Boolean {
			return _mipmapping;
		}
		
		public function set mipmapping(value:Boolean):void {
			if (_mipmapping != value) {
				_mipmapping = value;
				if (_texture) {
					_mipmapping ? uploadWithMipmaps(_texture, _data) : _texture.uploadFromBitmapData(_data);
				}
			}
		}
		
		public function get texture():Texture {
			return _texture;
		}
		
	}

}