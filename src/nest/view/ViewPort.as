package nest.view
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	import nest.control.mouse.MouseManager;
	import nest.control.EngineBase;
	import nest.view.cull.ICulling;
	import nest.view.effect.IPostEffect;
	import nest.view.manager.ISceneManager;
	import nest.view.process.IProcess;
	
	/** 
	 * Dispatched when context3d is created.
	 * @eventType flash.events.Event
	 */
	[Event(name = Event.CONTEXT3D_CREATE, type = "flash.events.Event")]
	
	/**
	 * ViewPort
	 */
	public class ViewPort extends EventDispatcher {
		
		private var _width:Number;
		private var _height:Number;
		private var _antiAlias:int = 0;
		
		private var _color:uint = 0x000000;
		private var _rgba:Vector.<Number> = new Vector.<Number>(4, true);
		private var _camPos:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var _diagram:Diagram;
		
		private var _mouseManager:MouseManager;
		private var _effect:IPostEffect;
		private var _culling:ICulling;
		private var _process:IProcess;
		
		public function ViewPort(width:Number, height:Number) {
			_diagram = new Diagram();
			
			_rgba[3] = 1;
			_width = width;
			_height = height;
			
			// setup scene
			EngineBase.stage3d.addEventListener(Event.CONTEXT3D_CREATE, init);
			EngineBase.stage3d.requestContext3D();
		}
		
		/**
		 * Project a point from world space to screen space.
		 * <p>If the point is in front of the camera, then result.z = 0, otherwise, result.z = 1.</p>
		 */
		public function projectVector(p:Vector3D):Vector3D {
			const vx:Number = _width * 0.5;
			const vy:Number = _height * 0.5;
			var result:Vector3D = Utils3D.projectVector(EngineBase.camera.pm, EngineBase.camera.invertMatrix.transformVector(p));
			result.x = result.x * vx + vx;
			result.y = vy - result.y * vy;
			return result;
		}
		
		/**
		 * Put this into a loop to draw your scene on stage3d.
		 */
		public function calculate(bitmapData:BitmapData = null):void {
			var context3d:Context3D = EngineBase.context3d;
			var camera:Camera3D = EngineBase.camera;
			var manager:ISceneManager = EngineBase.manager;
			
			if (_mouseManager && _mouseManager.type) _mouseManager.calculate();
			
			if (_effect) context3d.setRenderToTexture(_effect.textures[0], _effect.enableDepthAndStencil, _effect.antiAlias);
			context3d.clear(_rgba[0], _rgba[1], _rgba[2], _rgba[3]);
			
			_camPos[0] = camera.position.x;
			_camPos[1] = camera.position.y;
			_camPos[2] = camera.position.z;
			_camPos[3] = 1;
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, _camPos);
			
			manager.first = true;
			manager.culling = _culling;
			manager.process = _process;
			manager.calculate();
			
			if (_effect) {
				var effect:IPostEffect = _effect;
				while (effect) {
					effect.calculate();
					effect = effect.next;
				}
			}
			
			_diagram.update();
			
			if (bitmapData) context3d.drawToBitmapData(bitmapData);
			context3d.present();
		}
		
		private function init(e:Event):void {
			EngineBase.context3d = EngineBase.stage3d.context3D;
			EngineBase.context3d.enableErrorChecking = true;
			EngineBase.context3d.configureBackBuffer(_width, _height, _antiAlias, true);
			EngineBase.camera.aspect = _width / _height;
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
				if (EngineBase.context3d) {
					_width = value;
					EngineBase.context3d.configureBackBuffer(_width, _height, _antiAlias, true);
					EngineBase.camera.aspect = _width / _height;
					dispatchEvent(new Event(Event.RESIZE));
				}
			}
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function set height(value:Number):void {
			if (_height != value) {
				if (EngineBase.context3d) {
					_height = value;
					EngineBase.context3d.configureBackBuffer(_width, _height, _antiAlias, true);
					EngineBase.camera.aspect = _width / _height;
					dispatchEvent(new Event(Event.RESIZE));
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
				if (EngineBase.context3d) EngineBase.context3d.configureBackBuffer(_width, _height, _antiAlias, true);
			}
		}
		
		public function get diagram():Diagram {
			return _diagram;
		}
		
		public function get mouseManager():MouseManager {
			return _mouseManager;
		}
		
		/**
		 * Value this if you need 3d mouse event.
		 * <p>And don't forget to turn container&&mesh's mouseEnabled on.</p>
		 */
		public function set mouseManager(value:MouseManager):void {
			if (_mouseManager) _mouseManager.dispose();
			_mouseManager = value;
			if (_mouseManager) _mouseManager.init();
		}
		
		public function get effect():IPostEffect {
			return _effect;
		}
		
		/**
		 * Link post effect here.
		 * <p>You can have multi-effect by indicating effect's "next" method.</p>
		 * <p>view.effect = new PE();</p>
		 * <p>view.effect.next = new PE2();</p>
		 */
		public function set effect(value:IPostEffect):void {
			_effect = value;
		}
		
		public function get culling():ICulling {
			return _culling;
		}
		
		public function set culling(value:ICulling):void {
			_culling = value;
		}
		
		public function get process():IProcess {
			return _process;
		}
		
		public function set process(value:IProcess):void {
			_process = value;
		}
		
	}

}