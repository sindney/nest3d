package nest.object
{
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.Dictionary;
	
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.view.shader.Shader3D;
	import nest.view.TextureResource;
	
	/**
	 * Mesh
	 */
	public class Mesh extends Object3D implements IMesh {
		
		protected var _geom:Geometry;
		
		protected var _material:Vector.<TextureResource>;
		
		protected var _shader:Shader3D;
		
		protected var _bound:Bound;
		
		protected var _parameters:Dictionary;
		
		protected var _triangleCulling:String = Context3DTriangleFace.BACK;
		
		protected var _visible:Boolean = true;
		protected var _cliping:Boolean = true;
		protected var _alphaTest:Boolean = false;
		protected var _mouseEnabled:Boolean = false;
		protected var _ignoreRotation:Boolean = false;
		
		protected var _id:uint;
		
		public function Mesh(geom:Geometry, material:Vector.<TextureResource>, shader:Shader3D) {
			super();
			_geom = geom;
			_material = material;
			_shader = shader;
			_bound = new Bound();
			_parameters = new Dictionary();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get geom():Geometry {
			return _geom;
		}
		
		public function set geom(value:Geometry):void {
			_geom = value;
		}
		
		public function get material():Vector.<TextureResource> {
			return _material;
		}
		
		public function set material(value:Vector.<TextureResource>):void {
			_material = value;
		}
		
		public function get shader():Shader3D {
			return _shader;
		}
		
		public function set shader(value:Shader3D):void {
			_shader = value;
		}
		
		public function get bound():Bound {
			return _bound;
		}
		
		public function get parameters():Dictionary {
			return _parameters;
		}
		
		public function get visible():Boolean {
			return _visible;
		}
		
		public function set visible(value:Boolean):void {
			_visible = value;
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