package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	
	/**
	 * LightMapMaterial
	 */
	public class LightMapMaterial extends TextureMaterial {
		
		protected var _lightmap:Texture;
		protected var _lm_data:BitmapData;
		
		public function LightMapMaterial(lightmap:BitmapData, diffuse:BitmapData, specular:BitmapData = null, glossiness:int = 10, normalmap:BitmapData = null, mipmapping:Boolean = false) {
			super(diffuse, specular, glossiness, normalmap, mipmapping);
			_lm_data = lightmap;
		}
		
		override public function upload(context3D:Context3D):void {
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
			uploadLights(context3D);
			context3D.setTextureAt(0, _diffuse);
			if (_spec_data) context3D.setTextureAt(1, _specular);
			if (_nm_data) {
				context3D.setTextureAt(2, _normalmap);
				context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10, _vertData);
			}
			if (_lm_data) context3D.setTextureAt(3, _lightmap);
			if (_spec_data || _nm_data) context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 22, _fragData);
		}
		
		override public function unload(context3D:Context3D):void {
			if (_diffuse) context3D.setTextureAt(0, null);
			if (_specular) context3D.setTextureAt(1, null);
			if (_normalmap) context3D.setTextureAt(2, null);
			if (_lightmap) context3D.setTextureAt(3, null);
		}
		
		override public function dispose():void {
			if (_diffuse) _diffuse.dispose();
			if (_diff_data) _diff_data.dispose();
			if (_specular) _specular.dispose();
			if (_spec_data) _spec_data.dispose();
			if (_normalmap) _normalmap.dispose();
			if (_nm_data) _nm_data.dispose();
			if (_lightmap) _lightmap.dispose();
			if (_lm_data) _lm_data.dispose();
			_light = null;
			_vertData = null;
			_fragData = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get lightmap():BitmapData {
			return _lm_data;
		}
		
		public function set lightmap(value:BitmapData):void {
			if (_lm_data != value) {
				_lm_data = value;
				_changed = true;
			}
		}
		
	}

}