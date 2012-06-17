package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	
	/**
	 * TextureMaterial
	 */
	public class TextureMaterial implements IMaterial {
		
		private var _diff_data:BitmapData;
		private var _spec_data:BitmapData;
		private var _nm_data:BitmapData;
		private var _lm_data:BitmapData;
		private var _data:Vector.<Number>;
		
		private var _diffuse:Texture;
		private var _specular:Texture;
		private var _normalmap:Texture;
		private var _lightmap:Texture;
		private var _glossiness:int;
		
		private var _optimizeForRenderToTexture:Boolean = true;
		private var _mipmapping:Boolean = false;
		private var _changed:Boolean = false;
		
		public function TextureMaterial(diffuse:BitmapData, specular:BitmapData = null, glossiness:int = 10, normalmap:BitmapData = null, mipmapping:Boolean = false) {
			_data = new Vector.<Number>(4, true);
			_data[1] = 2;
			_data[2] = 1;
			_data[3] = 0;
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
				if (_lightmap) _lightmap.dispose();
				if (_lm_data) {
					_lightmap = context3D.createTexture(_lm_data.width, _lm_data.height, Context3DTextureFormat.BGRA, _optimizeForRenderToTexture);
					_mipmapping ? uploadWithMipmaps(_lightmap, _lm_data) : _lightmap.uploadFromBitmapData(_lm_data);
				}
			}
			context3D.setTextureAt(0, _diffuse);
			if (_spec_data) context3D.setTextureAt(1, _specular);
			if (_nm_data) context3D.setTextureAt(2, _normalmap);
			if (_spec_data || _nm_data) context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 21, _data);
			if (_lm_data) context3D.setTextureAt(3, _lightmap);
		}
		
		public function unload(context3D:Context3D):void {
			if (_diffuse) context3D.setTextureAt(0, null);
			if (_specular) context3D.setTextureAt(1, null);
			if (_normalmap) context3D.setTextureAt(2, null);
			if (_lightmap) context3D.setTextureAt(3, null);
		}
		
		public function dispose():void {
			if (_diffuse) _diffuse.dispose();
			if (_diff_data) _diff_data.dispose();
			if (_specular) _specular.dispose();
			if (_spec_data) _spec_data.dispose();
			if (_normalmap) _normalmap.dispose();
			if (_nm_data) _nm_data.dispose();
			if (_lightmap) _lightmap.dispose();
			if (_lm_data) _lm_data.dispose();
			_data = null;
		}
		
		private function uploadWithMipmaps(texture:Texture, bmd:BitmapData):void {
			var width:int = bmd.width;
			var height:int = bmd.height;
			var leve:int = 0;
			var image:BitmapData = new BitmapData(bmd.width, bmd.height);
			var matrix:Matrix = new Matrix();
			
			while (width > 0 && height > 0) {
				image.draw(bmd, matrix, null, null, null, true);
				texture.uploadFromBitmapData(image, leve);
				matrix.scale(0.5, 0.5);
				leve++;
				width >>= 1;
				height >>= 1;
			}
			image.dispose();
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
		
		public function get lightmap():BitmapData {
			return _lm_data;
		}
		
		public function set lightmap(value:BitmapData):void {
			if (_lm_data != value) {
				_lm_data = value;
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
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.materials.TextureMaterial]";
		}
		
	}

}