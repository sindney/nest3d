package nest.view.process 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.factory.ShaderFactory;
	import nest.object.IMesh;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * MouseProcess
	 * <p>Push this process before your target containerProcess.</p>
	 */
	public class MouseProcess implements IRenderProcess {
		
		private var id:uint;
		private var mouseX:Number = 0;
		private var mouseY:Number = 0;
		private var target:IMesh;
		private var program:Program3D;
		private var type:String;
		
		public var stage:Stage;
		public var containerProcess:IContainerProcess;
		
		public function MouseProcess(stage:Stage, containerProcess:IContainerProcess) {
			this.stage = stage;
			this.containerProcess = containerProcess;
			
			program = ViewPort.context3d.createProgram();
			program.upload(ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0"), 
							ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, "mov oc, fc0"));
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			stage.addEventListener(MouseEvent.CLICK, onMouseEvent);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onMouseEvent);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseEvent);
		}
		
		public function calculate():void {
			var camera:Camera3D = containerProcess.camera;
			var context3d:Context3D = ViewPort.context3d;
			var width:Number = ViewPort.width;
			var height:Number = ViewPort.height;
			
			if (mouseX <= width && mouseY <= height) {
				var pm:Vector.<Number> = camera.pm.rawData.concat();
				pm[8] = -mouseX * 2 / width;
				pm[9] = mouseY * 2 / height;
				camera.pm.copyRawDataFrom(pm);
				
				context3d.setRenderToBackBuffer();
				context3d.clear();
				
				var bmd:BitmapData = new BitmapData(1, 1, true, 0);
				var matrix:Matrix3D = new Matrix3D();
				var components:Vector.<Vector3D>;
				var mesh:IMesh;
				var i:int = 0;
				
				for each(mesh in containerProcess.objects) {
					if (mesh.mouseEnabled) {
						mesh.id = ++i;
						
						matrix.copyFrom(mesh.worldMatrix);
						matrix.append(camera.invertMatrix);
						if (mesh.ignoreRotation) {
							components = matrix.decompose();
							components[1].setTo(0, 0, 0);
							matrix.recompose(components);
						}
						matrix.append(camera.pm);
						
						context3d.setCulling(mesh.triangleCulling);
						context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
						context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, ((i >> 8) & 0xff) / 255, (i & 0xff) / 255, 1]));
						
						mesh.geom.upload(false, false);
						
						context3d.setProgram(program);
						context3d.drawTriangles(mesh.geom.indexBuffer);
						
						mesh.geom.unload();
					}
				}
				
				context3d.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				
				for each(mesh in containerProcess.alphaObjects) {
					if (mesh.mouseEnabled) {
						mesh.id = ++i;
						
						matrix.copyFrom(mesh.worldMatrix);
						matrix.append(camera.invertMatrix);
						if (mesh.ignoreRotation) {
							components = matrix.decompose();
							components[1].setTo(0, 0, 0);
							matrix.recompose(components);
						}
						matrix.append(camera.pm);
						
						context3d.setCulling(mesh.triangleCulling);
						context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
						context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, ((i >> 8) & 0xff) / 255, (i & 0xff) / 255, 1]));
						
						mesh.geom.upload(false, false);
						
						context3d.setProgram(program);
						context3d.drawTriangles(mesh.geom.indexBuffer);
						
						mesh.geom.unload();
					}
				}
				
				context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				
				context3d.drawToBitmapData(bmd);
				context3d.present();
				id = bmd.getPixel32(0, 0) & 0xffff;
				
				if (id != 0) {
					for each(mesh in containerProcess.objects) {
						if (mesh.id == id) {
							if (target != mesh) {
								if (target) target.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT));
								type = MouseEvent3D.MOUSE_OVER;
							}
							target = mesh;
						}
					}
					target.dispatchEvent(new MouseEvent3D(type));
				} else {
					if (target) target.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT));
					target = null;
				}
				
				pm[8] = 0;
				pm[9] = 0;
				camera.pm.copyRawDataFrom(pm);
			}
		}
		
		public function dispose():void {
			containerProcess = null;
			program.dispose();
			program = null;
			target = null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			stage.removeEventListener(MouseEvent.CLICK, onMouseEvent);
			stage.removeEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, onMouseEvent);
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseEvent);
			stage = null;
		}
		
		private function onMouseEvent(e:MouseEvent):void {
			mouseX = stage.mouseX;
			mouseY = stage.mouseY;
			switch(e.type) {
				case MouseEvent.MOUSE_MOVE:
					type = MouseEvent3D.MOUSE_MOVE;
					break;
				case MouseEvent.MOUSE_DOWN:
					type = MouseEvent3D.MOUSE_DOWN;
					break;
				case MouseEvent.CLICK:
					type = MouseEvent3D.CLICK;
					break;
				case MouseEvent.DOUBLE_CLICK:
					type = MouseEvent3D.DOUBLE_CLICK;
					break;
				case MouseEvent.RIGHT_CLICK:
					type = MouseEvent3D.RIGHT_CLICK;
					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:
					type = MouseEvent3D.RIGHT_MOUSE_DOWN;
					break;
			}
		}
		
	}

}