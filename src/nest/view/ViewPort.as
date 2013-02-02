package nest.view
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.events.EventDispatcher;
	
	import nest.view.process.IRenderProcess;
	
	/**
	 * ViewPort
	 */
	public class ViewPort extends EventDispatcher {
		
		private static var _context3d:Context3D;
		
		public static function get context3d():Context3D {
			return _context3d;
		}
		
		private static var _width:Number = 0;
		
		public static function get width():Number {
			return _width;
		}
		
		private static var _height:Number = 0;
		
		public static function get height():Number {
			return _height;
		}
		
		private var _processes:Vector.<IRenderProcess>;
		
		private var _diagram:Diagram;
		
		public function ViewPort(context3d:Context3D, processes:Vector.<IRenderProcess>) {
			_diagram = new Diagram();
			_context3d = context3d;
			this.processes = processes;
		}
		
		public function configure(width:Number = 512, height:Number = 512, antiAlias:int = 0, 
									enableDepthAndStencil:Boolean = true):void {
			_width = width;
			_height = height;
			_context3d.configureBackBuffer(width, height, antiAlias, enableDepthAndStencil);
		}
		
		/**
		 * Put this into a loop to draw your scene on stage3d.
		 */
		public function calculate(bitmapData:BitmapData = null):void {
			var i:int, j:int = _processes.length;
			
			for (i = 0; i < j; i++) {
				_processes[i].calculate();
			}
			
			_diagram.update();
			
			if (bitmapData) _context3d.drawToBitmapData(bitmapData);
			_context3d.present();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get processes():Vector.<IRenderProcess> {
			return _processes;
		}
		
		public function set processes(value:Vector.<IRenderProcess>):void {
			_processes = value;
		}
		
		public function get diagram():Diagram {
			return _diagram;
		}
		
	}

}