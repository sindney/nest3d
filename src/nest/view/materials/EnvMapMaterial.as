package nest.view.materials 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	
	/**
	 * EnvMapMaterial
	 */
	public class EnvMapMaterial extends TextureMaterial {
		
		protected var _cubicmap:CubeTexture;
		protected var _cm_data:Vector.<BitmapData>;
		
		public function EnvMapMaterial(cubicmap:Vector.<BitmapData>, reflectivity:Number, diffuse:BitmapData, specular:BitmapData = null, glossiness:int = 10, normalmap:BitmapData = null, mipmapping:Boolean = false) {
			super(diffuse, specular, glossiness, normalmap, mipmapping);
			this.reflectivity = reflectivity;
			_cm_data = cubicmap;
		}
		
		override public function upload(context3d:Context3D):void {
			if (_changed) {
				_changed = false;
				if (_diffuse) _diffuse.dispose();
				_diffuse = context3d.createTexture(_diff_data.width, _diff_data.height, Context3DTextureFormat.BGRA, true);
				_mipmapping ? uploadWithMipmaps(_diffuse, _diff_data) : _diffuse.uploadFromBitmapData(_diff_data);
				if (_specular) _specular.dispose();
				if (_spec_data) {
					_specular = context3d.createTexture(_spec_data.width, _spec_data.height, Context3DTextureFormat.BGRA, true);
					_mipmapping ? uploadWithMipmaps(_specular, _spec_data) : _specular.uploadFromBitmapData(_spec_data);
				}
				if (_normalmap) _normalmap.dispose();
				if (_nm_data) {
					_normalmap = context3d.createTexture(_nm_data.width, _nm_data.height, Context3DTextureFormat.BGRA, true);
					_mipmapping ? uploadWithMipmaps(_normalmap, _nm_data) : _normalmap.uploadFromBitmapData(_nm_data);
				}
				if (_cubicmap) _cubicmap.dispose();
				if (_cm_data[0]) {
					_cubicmap = context3d.createCubeTexture(_cm_data[0].width, Context3DTextureFormat.BGRA, true);
					uploadWithMipmaps(_cubicmap, _cm_data[0], 0);
					uploadWithMipmaps(_cubicmap, _cm_data[1], 1);
					uploadWithMipmaps(_cubicmap, _cm_data[2], 2);
					uploadWithMipmaps(_cubicmap, _cm_data[3], 3);
					uploadWithMipmaps(_cubicmap, _cm_data[4], 4);
					uploadWithMipmaps(_cubicmap, _cm_data[5], 5);
				}
			}
			uploadLights(context3d);
			context3d.setTextureAt(0, _diffuse);
			if (_spec_data) context3d.setTextureAt(1, _specular);
			if (_nm_data) {
				context3d.setTextureAt(2, _normalmap);
				context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10, _vertData);
			}
			if (_cm_data[0]) context3d.setTextureAt(3, _cubicmap);
			if (_spec_data || _nm_data || _cm_data[0]) context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 22, _fragData);
		}
		
		override public function unload(context3d:Context3D):void {
			if (_diffuse) context3d.setTextureAt(0, null);
			if (_specular) context3d.setTextureAt(1, null);
			if (_normalmap) context3d.setTextureAt(2, null);
			if (_cubicmap) context3d.setTextureAt(3, null);
		}
		
		override public function dispose():void {
			if (_diffuse) _diffuse.dispose();
			if (_diff_data) _diff_data.dispose();
			if (_specular) _specular.dispose();
			if (_spec_data) _spec_data.dispose();
			if (_normalmap) _normalmap.dispose();
			if (_nm_data) _nm_data.dispose();
			if (_cubicmap) _cubicmap.dispose();
			if (_cm_data[0]) {
				_cm_data[0].dispose();
				_cm_data[1].dispose();
				_cm_data[2].dispose();
				_cm_data[3].dispose();
				_cm_data[4].dispose();
				_cm_data[5].dispose();
			}
			_light = null;
			_vertData = null;
			_fragData = null;
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
		
		public function get reflectivity():Number {
			return _fragData[3];
		}
		
		public function set reflectivity(value:Number):void {
			_fragData[2] = value;
			_fragData[3] = 1 - value;
		}
		
	}

}