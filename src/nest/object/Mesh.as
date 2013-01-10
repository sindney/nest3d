package nest.object
{
	import flash.display3D.Context3DTriangleFace;
	
	import nest.object.geom.AABB;
	import nest.object.geom.Geometry;
	import nest.object.geom.IBound;
	import nest.view.material.IMaterial;
	
	/**
	 * Mesh
	 */
	public class Mesh extends Object3D implements IMesh {
		
		protected var _material:IMaterial;
		
		protected var _geom:Geometry;
		
		protected var _bound:IBound;
		
		protected var _triangleCulling:String = Context3DTriangleFace.BACK;
		
		protected var _visible:Boolean = true;
		protected var _cliping:Boolean = true;
		protected var _alphaTest:Boolean = false;
		protected var _mouseEnabled:Boolean = false;
		protected var _ignoreRotation:Boolean = false;
		protected var _castShadows:Boolean = false;
		
		protected var _id:uint;
		
		public function Mesh(geom:Geometry, material:IMaterial, bound:IBound = null) {
			super();
			_bound = _bound ? bound : new AABB();
			_material = material;
			this.geom = geom;
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
		
		public function get geom():Geometry {
			return _geom;
		}
		
		public function set geom(value:Geometry):void {
			if (_geom != value) {
				_geom = value;
				if (_geom && _bound)_bound.update(_geom.vertices);
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
			if (_bound != value) {
				_bound = value;
				if (_geom && _bound)_bound.update(_geom.vertices);
			}
		}
		
		public function get cliping():Boolean {
			return _cliping;
		}
		
		public function set cliping(value:Boolean):void {
			_cliping = value;
		}
		
		public function get alphaTest():Boolean {
			return _alphaTest;
		}
		
		public function set alphaTest(value:Boolean):void {
			_alphaTest = value;
		}
		
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void {
			_mouseEnabled = value;
		}
		
		public function get castShadows():Boolean {
			return _castShadows;
		}
		
		public function set castShadows(value:Boolean):void {
			_castShadows = value;
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function set id(value:uint):void {
			_id = value;
		}
		
		public function get ignoreRotation():Boolean {
			return _ignoreRotation;
		}
		
		public function set ignoreRotation(value:Boolean):void {
			_ignoreRotation = value;
		}
		
		public function get triangleCulling():String {
			return _triangleCulling;
		}
		
		public function set triangleCulling(value:String):void {
			_triangleCulling = value;
		}
		
	}

}