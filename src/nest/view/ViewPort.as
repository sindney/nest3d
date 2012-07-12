package nest.view
{
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D
	
	import nest.object.IContainer3D;
	import nest.view.managers.ISceneManager;
	
	/** 
	 * Dispatched when context3D is created.
	 * @eventType flash.events.Event
	 */
	[Event(name = Event.CONTEXT3D_CREATE, type = "flash.events.Event")]
	
	/**
	 * ViewPort
	 */
	public class ViewPort extends EventDispatcher {
		
		private var stage3d:Stage3D;
		
		private var _context3D:Context3D;
		private var _width:Number;
		private var _height:Number;
		private var _antiAlias:int = 0;
		
		private var _color:uint = 0x000000;
		private var _rgba:Vector.<Number> = new Vector.<Number>(4, true);
		private var _camPos:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var _fog:Boolean = false;
		private var _fogColor:Vector.<Number> = new Vector.<Number>(4, true);
		private var _fogData:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var _diagram:Diagram;
		
		private var _camera:Camera3D;
		private var _root:IContainer3D;
		private var _manager:ISceneManager;
		
		public function ViewPort(width:Number, height:Number, stage3d:Stage3D, camera:Camera3D, root:IContainer3D, manager:ISceneManager) {
			this.stage3d = stage3d;
			
			_camera = camera;
			_root = root;
			_manager = manager;
			_manager.camera = _camera;
			_manager.root = _root;
			
			_rgba[3] = 1;
			
			_width = width;
			_height = height;
			
			_diagram = new Diagram();
			
			// setup scene
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, init);
			stage3d.requestContext3D();
		}
		
		public function setupFog(color:uint, max:Number, min:Number):void {
			_fogColor[0] = ((color >> 16) & 0xFF) / 255;
			_fogColor[1] = ((color >> 8) & 0xFF) / 255;
			_fogColor[2] = (color & 0xFF) / 255;
			_fogColor[3] = 1;
			_fogData[0] = max * max;
			_fogData[1] = min * min;
			_fogData[2] = _fogData[3] = 0;
		}
		
		/**
		 * Project a point from world space to screen space.
		 * <p>If the point is in front of the camera, then result.z = 0, otherwise, result.z = 1.</p>
		 */
		public function projectVector(p:Vector3D):Vector3D {
			const vx:Number = _width * 0.5;
			const vy:Number = _height * 0.5;
			var result:Vector3D = Utils3D.projectVector(_camera.pm, _camera.invertMatrix.transformVector(p));
			result.x = result.x * vx + vx;
			result.y = vy - result.y * vy;
			return result;
		}
		
		/**
		 * Put this into a loop to draw your scene on stage3d.
		 */
		public function calculate(bitmapData:BitmapData = null):void {
			if (!_camera || !_root || !_context3D || !_manager) return;
			
			_context3D.clear(_rgba[0], _rgba[1], _rgba[2], _rgba[3]);
			
			_diagram.update();
			
			if (camera.changed) camera.recompose();
			
			_camPos[0] = camera.position.x;
			_camPos[1] = camera.position.y;
			_camPos[2] = camera.position.z;
			_camPos[3] = 1;
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, _camPos);
			
			if (_fog) {
 				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, _fogData);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 21, _fogColor);
			}
			
			_manager.calculate();
			
			if (bitmapData) _context3D.drawToBitmapData(bitmapData);
			_context3D.present();
		}
		
		private function init(e:Event):void {
			_context3D = stage3d.context3D;
			_context3D.configureBackBuffer(_width, _height, _antiAlias, true);
			camera.aspect = _width / _height;
			_manager.context3D = _context3D;
			dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get width():Number {
			return _width;
		}
		
		public function set width(value:Number):void {
			if (_width != value) {
				if (_context3D) {
					_width = value;
					_context3D.configureBackBuffer(_width, _height, _antiAlias, true);
					camera.aspect = _width / _height;
				}
			}
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function set height(value:Number):void {
			if (_height != value) {
				if (_context3D) {
					_height = value;
					_context3D.configureBackBuffer(_width, _height, _antiAlias, true);
					camera.aspect = _width / _height;
				}
			}
		}
		
		public function get alpha():Number {
			return _rgba[3];
		}
		
		public function set alpha(value:Number):void {
			_rgba[3] = value;
		}
		
		public function get color():uint {
			return _color;
		}
		
		/**
		 * Set Background color.
		 */
		public function set color(value:uint):void {
			_color = value;
			_rgba[0] = ((value >> 16) & 0xFF) / 255;
			_rgba[1] = ((value >> 8) & 0xFF) / 255;
			_rgba[2] = (value & 0xFF) / 255;
		}
		
		public function get antiAlias():int {
			return _antiAlias;
		}
		
		public function set antiAlias(value:int):void {
			if (_antiAlias != value) {
				_antiAlias = value;
				if (_context3D) _context3D.configureBackBuffer(_width, _height, _antiAlias, true);
			}
		}
		
		public function get diagram():Diagram {
			return _diagram;
		}
		
		public function get context3D():Context3D {
			return _context3D;
		}
		
		public function get camera():Camera3D {
			return _camera;
		}
		
		public function get root():IContainer3D {
			return _root;
		}
		
		public function get manager():ISceneManager {
			return _manager;
		}
		
		public function set manager(value:ISceneManager):void {
			_manager = value;
			_manager.camera = _camera;
			_manager.root = _root;
			_manager.context3D = _context3D;
		}
		
		public function get fog():Boolean {
			return _fog;
		}
		
		public function set fog(value:Boolean):void {
			_fog = value;
		}
		
	}

}