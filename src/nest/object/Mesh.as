package nest.object
{
	import flash.display3D.Context3DTriangleFace;
	
	import nest.control.controller.MouseEvent3D;
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.object.geom.SkinInfo;
	import nest.view.shader.Shader3D;
	import nest.view.TextureResource;
	
	[MouseEvent3D(name = "mouseDown", type = "nest.control.controller.MouseEvent3D")]
	[MouseEvent3D(name = "mouseOver", type = "nest.control.controller.MouseEvent3D")]
	[MouseEvent3D(name = "mouseMove", type = "nest.control.controller.MouseEvent3D")]
	[MouseEvent3D(name = "mouseOut", type = "nest.control.controller.MouseEvent3D")]
	[MouseEvent3D(name = "click", type = "nest.control.controller.MouseEvent3D")]
	[MouseEvent3D(name = "doubleClick", type = "nest.control.controller.MouseEvent3D")]
	[MouseEvent3D(name = "rightClick", type = "nest.control.controller.MouseEvent3D")]
	[MouseEvent3D(name = "rightMouseDown", type = "nest.control.controller.MouseEvent3D")]
	
	/**
	 * Mesh
	 */
	public class Mesh extends Object3D implements IMesh {
		
		protected var _geometries:Vector.<Geometry>;
		protected var _materials:Vector.<Vector.<TextureResource>>;
		protected var _shaders:Vector.<Shader3D>;
		
		protected var _skinInfo:SkinInfo;
		
		protected var _bound:Bound;
		protected var _triangleCulling:String = Context3DTriangleFace.BACK;
		
		protected var _visible:Boolean = true;
		protected var _cliping:Boolean = true;
		protected var _alphaTest:Boolean = false;
		protected var _mouseEnabled:Boolean = false;
		protected var _ignoreRotation:Boolean = false;
		protected var _ignorePosition:Boolean = false;
		protected var _id:uint = 0;
		
		public function Mesh(create:Boolean = true, geometries:Vector.<Geometry> = null, materials:Vector.<Vector.<TextureResource>> = null, shaders:Vector.<Shader3D> = null, bound:Bound = null) {
			if (create) {
				_geometries = new Vector.<Geometry>();
				_materials = new Vector.<Vector.<TextureResource>>();
				_shaders = new Vector.<Shader3D>();
				_bound = new Bound();
			} else {
				_geometries = geometries;
				_materials = materials;
				_shaders = shaders;
				_bound = bound;
			}
		}
		
		public function dispose(all:Boolean = true):void {
			if (all) {
				for each(var geom:Geometry in _geometries) geom.dispose();
				for each(var mats:Vector.<TextureResource> in _materials) {
					for each(var mat:TextureResource in mats) mat.dispose();
				}
				for each(var shader:Shader3D in _shaders) shader.dispose();
			}
			_geometries = null;
			_materials = null;
			_shaders = null;
			_skinInfo = null;
			_bound = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get geometries():Vector.<Geometry> {
			return _geometries;
		}
		
		public function set geometries(value:Vector.<Geometry>):void {
			_geometries = value;
		}
		
		public function get materials():Vector.<Vector.<TextureResource>> {
			return _materials;
		}
		
		public function set materials(value:Vector.<Vector.<TextureResource>>):void {
			_materials = value;
		}
		
		public function get shaders():Vector.<Shader3D> {
			return _shaders;
		}
		
		public function set shaders(value:Vector.<Shader3D>):void {
			_shaders = value;
		}
		
		public function get skinInfo():SkinInfo {
			return _skinInfo;
		}
		
		public function set skinInfo(value:SkinInfo):void {
			_skinInfo = value;
		}
		
		public function get bound():Bound {
			return _bound;
		}
		
		public function set bound(value:Bound):void {
			_bound = value;
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
		
		public function get triangleCulling():String {
			return _triangleCulling;
		}
		
		public function set triangleCulling(value:String):void {
			_triangleCulling = value;
		}
		
		public function get ignoreRotation():Boolean {
			return _ignoreRotation;
		}
		
		public function set ignoreRotation(value:Boolean):void {
			_ignoreRotation = value;
		}
		
		public function get ignorePosition():Boolean {
			return _ignorePosition;
		}
		
		public function set ignorePosition(value:Boolean):void {
			_ignorePosition = value;
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function set id(value:uint):void {
			_id = value;
		}
		
	}

}