package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	
	/**
	 * TextureMaterial
	 */
	public class TextureMaterial implements IMaterial {
		
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
		
		protected var _diff_data:BitmapData;
		protected var _spec_data:BitmapData;
		protected var _nm_data:BitmapData;
		
		protected var _diffuse:Texture;
		protected var _specular:Texture;
		protected var _normalmap:Texture;
		protected var _glossiness:int;
		
		protected var _data:Vector.<Number>;
		protected var _optimizeForRenderToTexture:Boolean = true;
		protected var _mipmapping:Boolean = false;
		protected var _changed:Boolean = false;
		
		public function TextureMaterial(diffuse:BitmapData, specular:BitmapData = null, glossiness:int = 10, normalmap:BitmapData = null, mipmapping:Boolean = false) {
			_data = new Vector.<Number>(4, true);
			_data[1] = 1;
			this.diffuse = diffuse;
			this.specular = specular;
			this.glossiness = glossiness;
			this.normalmap = normalmap;
			this.mipmapping = mipmapping;
		}
		
		public function upload(context3D:Context3D):void {
			if (_changed) {
				_changed = false;
				if (_diffuse) _diffuse.dispose();
				_diffuse = context3D.createTexture(_diff_data.width, _diff_data.height, Context3DTextureFormat.BGRA, _optimizeForRenderToTexture);
				_mipmapping ? uploadWithMipmaps(_diffuse, _diff_data) : _diffuse.uploadFromBitmapData(_diff_data);
				if (_specular) _specular.dispose();
				if (_spec_data) {
					_specular = context3D.createTexture(_spec_data.width, _spec_data.height, Context3DTextureFormat.BGRA, _optimizeForRenderToTexture);
					_mipmapping ? uploadWithMipmaps(_specular, _spec_data) : _specular.uploadFromBitmapData(_spec_data);
				}
				if (_normalmap) _normalmap.dispose();
				if (_nm_data) {
					_normalmap = context3D.createTexture(_nm_data.width, _nm_data.height, Context3DTextureFormat.BGRA, _optimizeForRenderToTexture);
					_mipmapping ? uploadWithMipmaps(_normalmap, _nm_data) : _normalmap.uploadFromBitmapData(_nm_data);
				}
			}
			context3D.setTextureAt(0, _diffuse);
			if (_spec_data) context3D.setTextureAt(1, _specular);
			if (_nm_data) context3D.setTextureAt(2, _normalmap);
			if (_spec_data || _nm_data) context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 22, _data);
		}
		
		public function unload(context3D:Context3D):void {
			if (_diffuse) context3D.setTextureAt(0, null);
			if (_specular) context3D.setTextureAt(1, null);
			if (_normalmap) context3D.setTextureAt(2, null);
		}
		
		public function dispose():void {
			if (_diffuse) _diffuse.dispose();
			if (_diff_data) _diff_data.dispose();
			if (_specular) _specular.dispose();
			if (_spec_data) _spec_data.dispose();
			if (_normalmap) _normalmap.dispose();
			if (_nm_data) _nm_data.dispose();
			_data = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get diffuse():BitmapData {
			return _diff_data;
		}
		
		public function set diffuse(value:BitmapData):void {
			if (_diff_data != value) {
				_diff_data = value;
				_changed = true;
			}
		}
		
		public function get specular():BitmapData {
			return _spec_data;
		}
		
		public function set specular(value:BitmapData):void {
			if (_spec_data != value) {
				_spec_data = value;
				_changed = true;
			}
		}
		
		public function get normalmap():BitmapData {
			return _nm_data;
		}
		
		public function set normalmap(value:BitmapData):void {
			if (_nm_data != value) {
				_nm_data = value;
				_changed = true;
			}
		}
		
		public function get glossiness():int {
			return _glossiness;
		}
		
		public function set glossiness(value:int):void {
			_glossiness = _data[0] = value;
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
		
		public function get uv():Boolean {
			return true;
		}
		
		public function get mipmapping():Boolean {
			return _mipmapping;
		}
		
		public function set mipmapping(value:Boolean):void {
			if (_mipmapping != value) {
				_mipmapping = value;
				_changed = true;
			}
		}
		
	}

}