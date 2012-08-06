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
	
	import nest.view.lights.*;
	
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
		
		protected var _light:AmbientLight;
		
		protected var _vertData:Vector.<Number>;
		protected var _fragData:Vector.<Number>;
		protected var _mipmapping:Boolean = false;
		protected var _changed:Boolean = false;
		
		public function TextureMaterial(diffuse:BitmapData, specular:BitmapData = null, glossiness:int = 10, normalmap:BitmapData = null, mipmapping:Boolean = false) {
			_vertData = new Vector.<Number>(4, true);
			_vertData[0] = _vertData[2] = _vertData[3] = 0;
			_vertData[1] = 1;
			_fragData = new Vector.<Number>(4, true);
			_fragData[1] = 1;
			this.diffuse = diffuse;
			this.specular = specular;
			this.glossiness = glossiness;
			this.normalmap = normalmap;
			this.mipmapping = mipmapping;
		}
		
		public function upload(context3d:Context3D):void {
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
			}
			uploadLights(context3d);
			context3d.setTextureAt(0, _diffuse);
			if (_spec_data) context3d.setTextureAt(1, _specular);
			if (_nm_data) {
				context3d.setTextureAt(2, _normalmap);
				context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10, _vertData);
			}
			if (_spec_data || _nm_data) context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 22, _fragData);
		}
		
		public function unload(context3d:Context3D):void {
			if (_diffuse) context3d.setTextureAt(0, null);
			if (_specular) context3d.setTextureAt(1, null);
			if (_normalmap) context3d.setTextureAt(2, null);
		}
		
		public function dispose():void {
			if (_diffuse) _diffuse.dispose();
			if (_diff_data) _diff_data.dispose();
			if (_specular) _specular.dispose();
			if (_spec_data) _spec_data.dispose();
			if (_normalmap) _normalmap.dispose();
			if (_nm_data) _nm_data.dispose();
			_light = null;
			_vertData = null;
			_fragData = null;
		}
		
		protected function uploadLights(context3d:Context3D):void {
			var light:ILight = _light;
			var j:int = 1;
			while (light) {
				if (light is AmbientLight) {
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, light.rgba);
				} else if (light is DirectionalLight) {
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as DirectionalLight).direction);
					j += 2;
				} else if (light is PointLight) {
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as PointLight).position);
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 2, (light as PointLight).radius);
					j += 3;
				} else if (light is SpotLight) {
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as SpotLight).position);
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 2, (light as SpotLight).direction);
					context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 3, (light as SpotLight).lightParameters);
					j += 4;
				}
				light = light.next;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Root light is an AmbientLight.
		 * <p>Link new light source to light.next.</p>
		 * <p>There's 21 empty fc left.</p>
		 * <p>Ambient light absorbs 1 fc.</p>
		 * <p>Directional light takes 2.</p>
		 * <p>PointLight light takes 3.</p>
		 * <p>SpotLight light takes 4.</p>
		 */
		public function get light():AmbientLight {
			return _light;
		}
		
		public function set light(value:AmbientLight):void {
			_light = value;
		}
		
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
			_glossiness = _fragData[0] = value;
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