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
	import nest.control.GlobalMethods;
	import nest.view.culls.BasicCulling;
	import nest.view.culls.ICulling;
	import nest.view.effects.IPostEffect;
	import nest.view.managers.ISceneManager;
	
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
		
		private var _fog:Boolean = false;
		private var _fogColor:Vector.<Number> = new Vector.<Number>(4, true);
		private var _fogData:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var _diagram:Diagram;
		
		private var _mouseManager:MouseManager;
		private var _effect:IPostEffect;
		private var _culling:ICulling;
		
		public function ViewPort(width:Number, height:Number) {
			_culling = new BasicCulling();
			_diagram = new Diagram();
			
			_rgba[3] = 1;
			_width = width;
			_height = height;
			
			// setup scene
			GlobalMethods.stage3d.addEventListener(Event.CONTEXT3D_CREATE, init);
			GlobalMethods.stage3d.requestContext3D();
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
			var result:Vector3D = Utils3D.projectVector(GlobalMethods.camera.pm, GlobalMethods.camera.invertMatrix.transformVector(p));
			result.x = result.x * vx + vx;
			result.y = vy - result.y * vy;
			return result;
		}
		
		/**
		 * Put this into a loop to draw your scene on stage3d.
		 */
		public function calculate(bitmapData:BitmapData = null):void {
			var context3d:Context3D = GlobalMethods.context3d;
			var camera:Camera3D = GlobalMethods.camera;
			var manager:ISceneManager = GlobalMethods.manager;
			
			if (_mouseManager && _mouseManager.type) _mouseManager.calculate();
			
			if (_effect) context3d.setRenderToTexture(_effect.textures[0], _effect.enableDepthAndStencil, _effect.antiAlias);
			context3d.clear(_rgba[0], _rgba[1], _rgba[2], _rgba[3]);
			
			_diagram.update();
			if (camera.changed) camera.recompose();
			_camPos[0] = camera.position.x;
			_camPos[1] = camera.position.y;
			_camPos[2] = camera.position.z;
			_camPos[3] = 1;
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, _camPos);
			
			if (_fog) {
 				context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, _fogData);
				context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 21, _fogColor);
			}
			
			manager.first = true;
			manager.culling = culling;
			manager.process = null;
			manager.calculate();
			
			if (_effect) {
				var effect:IPostEffect = _effect;
				while (effect) {
					effect.calculate();
					effect = effect.next;
				}
			}
			
			if (bitmapData) context3d.drawToBitmapData(bitmapData);
			context3d.present();
		}
		
		private function init(e:Event):void {
			GlobalMethods.context3d = GlobalMethods.stage3d.context3D;
			GlobalMethods.context3d.enableErrorChecking = true;
			GlobalMethods.context3d.configureBackBuffer(_width, _height, _antiAlias, true);
			GlobalMethods.camera.aspect = _width / _height;
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
				if (GlobalMethods.context3d) {
					_width = value;
					GlobalMethods.context3d.configureBackBuffer(_width, _height, _antiAlias, true);
					GlobalMethods.camera.aspect = _width / _height;
					dispatchEvent(new Event(Event.RESIZE));
				}
			}
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function set height(value:Number):void {
			if (_height != value) {
				if (GlobalMethods.context3d) {
					_height = value;
					GlobalMethods.context3d.configureBackBuffer(_width, _height, _antiAlias, true);
					GlobalMethods.camera.aspect = _width / _height;
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
				if (GlobalMethods.context3d) GlobalMethods.context3d.configureBackBuffer(_width, _height, _antiAlias, true);
			}
		}
		
		public function get diagram():Diagram {
			return _diagram;
		}
		
		public function get fog():Boolean {
			return _fog;
		}
		
		public function set fog(value:Boolean):void {
			_fog = value;
		}
		
		public function get mouseManager():MouseManager {
			return _mouseManager;
		}
		
		public function set mouseManager(value:MouseManager):void {
			if (_mouseManager) _mouseManager.dispose();
			_mouseManager = value;
			if (_mouseManager) _mouseManager.init();
		}
		
		public function get effect():IPostEffect {
			return _effect;
		}
		
		public function set effect(value:IPostEffect):void {
			_effect = value;
		}
		
		public function get culling():ICulling {
			return _culling;
		}
		
		public function set culling(value:ICulling):void {
			_culling = value;
		}
		
	}

}