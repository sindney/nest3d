package nest.object
{
	import flash.display3D.Context3DTriangleFace;
	
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.view.shader.Shader3D;
	
	[Event(name = "mouseDown", type = "nest.control.controller.MouseEvent3D")]
	[Event(name = "mouseOver", type = "nest.control.controller.MouseEvent3D")]
	[Event(name = "mouseMove", type = "nest.control.controller.MouseEvent3D")]
	[Event(name = "mouseOut", type = "nest.control.controller.MouseEvent3D")]
	[Event(name = "click", type = "nest.control.controller.MouseEvent3D")]
	[Event(name = "doubleClick", type = "nest.control.controller.MouseEvent3D")]
	[Event(name = "rightClick", type = "nest.control.controller.MouseEvent3D")]
	[Event(name = "rightMouseDown", type = "nest.control.controller.MouseEvent3D")]
	
	/**
	 * Mesh
	 */
	public class Mesh extends Object3D implements IMesh {
		
		protected var _geometry:Geometry;
		protected var _shaders:Vector.<Shader3D>;
		
		protected var _bound:Bound;
		protected var _triangleCulling:String = Context3DTriangleFace.BACK;
		
		protected var _visible:Boolean = true;
		protected var _cliping:Boolean = true;
		protected var _alphaTest:Boolean = false;
		protected var _mouseEnabled:Boolean = false;
		protected var _ignoreRotation:Boolean = false;
		protected var _ignorePosition:Boolean = false;
		protected var _id:uint = 0;
		protected var _castShadows:Boolean = false;
		
		public function Mesh(geometry:Geometry = null, shaders:Vector.<Shader3D> = null, bound:Bound = null) {
			super();
			_geometry = geometry;
			_shaders = shaders ? shaders : new Vector.<Shader3D>();
			_bound = bound ? bound : new Bound();
		}
		
		/**
		 * @param	all Dispose geometry buffers and shader textures.
		 */
		public function dispose(all:Boolean = true):void {
			if (all) {
				_geometry.dispose();
				for each(var shader:Shader3D in _shaders) shader.dispose();
			}
			_geometry = null;
			_shaders = null;
			_bound = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get geometry():Geometry {
			return _geometry;
		}
		
		public function set geometry(value:Geometry):void {
			_geometry = value;
		}
		
		public function get shaders():Vector.<Shader3D> {
			return _shaders;
		}
		
		public function set shaders(value:Vector.<Shader3D>):void {
			_shaders = value;
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
		
		public function get castShadows():Boolean {
			return _castShadows;
		}
		
		public function set castShadows(value:Boolean):void {
			_castShadows = value;
		}
		
	}

}