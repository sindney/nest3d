package nest.control.mouse 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.GlobalMethods;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.view.culls.MouseCulling;
	import nest.view.managers.ISceneManager;
	import nest.view.Camera3D;
	import nest.view.Shader3D;
	
	/**
	 * MouseManager
	 */
	public class MouseManager {
		
		private var _type:String;
		
		private var draw:Matrix3D;
		private var culling:MouseCulling;
		
		private var id:uint;
		private var mouseX:Number;
		private var mouseY:Number;
		private var target:IMesh;
		private var map:BitmapData;
		
		private var uvShader:Shader3D;
		
		public function MouseManager() {
			draw = new Matrix3D();
			culling = new MouseCulling();
			
			uvShader = new Shader3D();
			uvShader.setFromString("m44 op, va0, vc0\nmov v0, va1" , "mov oc, v0", false);
			
			map = new BitmapData(1, 1, true, 0);
		}
		
		public function init():void {
			GlobalMethods.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.CLICK, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.RIGHT_CLICK, onMouseEvent);
			GlobalMethods.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseEvent);
		}
		
		public function dispose():void {
			GlobalMethods.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.CLICK, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.RIGHT_CLICK, onMouseEvent);
			GlobalMethods.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseEvent);
		}
		
		public function calculate():void {
			var camera:Camera3D = GlobalMethods.camera;
			var context3d:Context3D = GlobalMethods.context3d;
			var manager:ISceneManager = GlobalMethods.manager;
			var width:Number = GlobalMethods.view.width;
			var height:Number = GlobalMethods.view.height;
			var container:IContainer3D;
			
			if (context3d && mouseX <= width && mouseY <= height) {
				var pm:Vector.<Number> = camera.pm.rawData.concat();
				pm[8] = -mouseX * 2 / width;
				pm[9] = mouseY * 2 / height;
				camera.pm.copyRawDataFrom(pm);
				
				context3d.clear(0, 0, 0, 0);
				culling.id = 0;
				manager.first = false;
				manager.culling = culling;
				manager.calculate();
				context3d.drawToBitmapData(map);
				context3d.present();
				id = map.getPixel32(0, 0) & 0xffff;
				
				if (target) target.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT));
				if (id != 0) {
					var color:uint;
					var mesh:IMesh;
					var event:MouseEvent3D = new MouseEvent3D(_type);
					var objects:Vector.<IMesh> = GlobalMethods.manager.objects;
					for each(mesh in objects) {
						if (mesh.id == id) target = mesh;
					}
					draw.copyFrom(target.matrix);
					draw.append(camera.invertMatrix);
					draw.append(camera.pm);
					
					context3d.clear(0, 0, 0, 0);
					context3d.setCulling(target.culling);
					context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, draw, true);
					
					// uv
					target.data.upload(context3d, true, false);
					if (uvShader.changed) {
						uvShader.changed = false;
						if (!uvShader.program) uvShader.program = context3d.createProgram();
						uvShader.program.upload(uvShader.vertex, uvShader.fragment);
					}
					
					context3d.setProgram(uvShader.program);
					context3d.drawTriangles(target.data.indexBuffer);
					target.data.unload(context3d);
					
					context3d.drawToBitmapData(map);
					context3d.present();
					
					color = map.getPixel32(0, 0);
					event.uv[0] = ((color >> 16) & 0xff) / 255;
					event.uv[1] = ((color >> 8) & 0xff) / 255;
					target.dispatchEvent(event);
				} else {
					target = null;
				}
				
				pm[8] = 0;
				pm[9] = 0;
				camera.pm.copyRawDataFrom(pm);
			}
			_type = null;
		}
		
		private function onMouseEvent(e:MouseEvent):void {
			mouseX = GlobalMethods.stage.mouseX;
			mouseY = GlobalMethods.stage.mouseY;
			switch(e.type) {
				case MouseEvent.MOUSE_MOVE:
					_type = MouseEvent3D.MOUSE_OVER;
					break;
				case MouseEvent.MOUSE_DOWN:
					_type = MouseEvent3D.MOUSE_DOWN;
					break;
				case MouseEvent.CLICK:
					_type = MouseEvent3D.CLICK;
					break;
				case MouseEvent.DOUBLE_CLICK:
					_type = MouseEvent3D.DOUBLE_CLICK;
					break;
				case MouseEvent.RIGHT_CLICK:
					_type = MouseEvent3D.RIGHT_CLICK;
					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:
					_type = MouseEvent3D.RIGHT_MOUSE_DOWN;
					break;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get type():String {
			return _type;
		}
		
	}

}