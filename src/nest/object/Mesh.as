package nest.object
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.data.MeshData;
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.geom.IBound;
	import nest.view.materials.IMaterial;
	import nest.view.BlendMode3D;
	import nest.view.Shader3D;
	
	/**
	 * Mesh
	 */
	public class Mesh extends Object3D implements IMesh {
		
		protected var _material:IMaterial;
		
		protected var _data:MeshData;
		
		protected var _bound:IBound;
		
		protected var _blendMode:BlendMode3D;
		
		protected var _culling:String = Context3DTriangleFace.BACK;
		
		protected var _visible:Boolean = true;
		protected var _cliping:Boolean = true;
		protected var _alphaTest:Boolean = false;
		protected var _mouseEnabled:Boolean = false;
		
		protected var _id:uint;
		
		public function Mesh(data:MeshData, material:IMaterial, bound:IBound = null) {
			super();
			_material = material;
			_blendMode = new BlendMode3D();
			
			if (bound) {
				_bound = bound;
			} else {
				_bound = new AABB();
			}
			
			this.data = data;
		}
		
		public function clone():IMesh {
			var bound:IBound;
			if (_bound is BSphere) bound = new BSphere();
			var result:Mesh = new Mesh(_data, _material, bound);
			result.blendMode.source = _blendMode.source;
			result.blendMode.dest = _blendMode.dest;
			result.blendMode.depthMask = _blendMode.depthMask;
			result.cliping = _cliping;
			result.culling = _culling;
			result.visible = _visible;
			result.alphaTest = _alphaTest;
			return result;
		}
		
		override public function decompose():void {
			_components = _matrix.decompose(_orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.appendScale(1 / _components[2].x, 1 / _components[2].y, 1 / _components[2].z);
			_invertMatrix.invert();
			_changed = false;
		}
		
		override public function recompose():void {
			_matrix.recompose(_components, _orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.appendScale(1 / _components[2].x, 1 / _components[2].y, 1 / _components[2].z);
			_invertMatrix.invert();
			_changed = false;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get visible():Boolean {
			return _visible;
		}
		
		public function set visible(value:Boolean):void {
			_visible = value;
		}
		
		public function get data():MeshData {
			return _data;
		}
		
		public function set data(value:MeshData):void {
			if (_data != value) {
				_data = value;
				if (_data && _bound) _bound.update(_data.vertices);
			}
		}
		
		public function get material():IMaterial {
			return _material;
		}
		
		public function set material(value:IMaterial):void {
			if (_material != value)_material = value;
		}
		
		public function get bound():IBound {
			return _bound;
		}
		
		public function set bound(value:IBound):void {
			_bound = value;
			if (_data && _bound) _bound.update(_data.vertices);
		}
		
		public function get cliping():Boolean {
			return _cliping;
		}
		
		public function set cliping(value:Boolean):void {
			_cliping = value;
		}
		
		public function get culling():String {
			return _culling;
		}
		
		public function set culling(value:String):void {
			_culling = value;
		}
		
		public function get blendMode():BlendMode3D {
			return _blendMode;
		}
		
		public function get alphaTest():Boolean {
			return _alphaTest;
		}
		
		public function set alphaTest(value:Boolean):void {
			_alphaTest = value;
		}
		
		public function get scale():Vector3D {
			return _components[2];
		}
		
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void {
			_mouseEnabled = value;
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function set id(value:uint):void {
			_id = value;
		}
		
	}

}