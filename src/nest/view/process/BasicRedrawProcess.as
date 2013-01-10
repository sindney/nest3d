package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	
	import nest.object.IMesh;
	
	/**
	 * BasicRedrawProcess
	 */
	public class BasicRedrawProcess extends RenderProcess implements IRedrawProcess {
		
		protected var _meshProcess:IMeshProcess;
		protected var _containerProcess:IContainerProcess;
		
		public function BasicRedrawProcess() {
			
		}
		
		public function calculate(context3d:Context3D, next:IRenderProcess):void {
			var object:IMesh;
			
			context3d.setRenderToTexture(_texture, _enableDepthAndStencil, _antiAlias);
			context3d.clear(_containerProcess.rgba[0], _containerProcess.rgba[1], 
							_containerProcess.rgba[2], _containerProcess.rgba[3]);
			
			_meshProcess.initialize();
			for each(object in _containerProcess.objects) {
				_meshProcess.calculate(object, _containerProcess.ivm, _containerProcess.pm);
			}
		}
		
		public function dispose():void {
			super.dispose();
			_meshProcess = null;
			_containerProcess = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get meshProcess():IMeshProcess {
			return _meshProcess;
		}
		
		public function set meshProcess(value:IMeshProcess):void {
			_meshProcess = value;
		}
		
		public function get containerProcess():IContainerProcess {
			return _containerProcess;
		}
		
		public function set containerProcess(value:IContainerProcess):void {
			_containerProcess = value;
		}
		
	}

}