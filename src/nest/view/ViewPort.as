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
		
		public static var output:String = "";
		
		private static var _context3d:Context3D;
		
		public static function get context3d():Context3D {
			return _context3d;
		}
		
		private var _processes:Vector.<IRenderProcess>;
		
		private var _diagram:Diagram;
		
		public function ViewPort(context3d:Context3D, processes:Vector.<IRenderProcess>) {
			_diagram = new Diagram();
			_context3d = context3d;
			this.processes = processes;
		}
		
		/**
		 * Put this into a loop to draw your scene on stage3d.
		 */
		public function calculate(bitmapData:BitmapData = null, present:Boolean = true):void {
			var i:int, j:int = _processes.length;
			var process:IRenderProcess;
			
			for (i = 0; i < j; i++) {
				process = _processes[i];
				process.calculate((i + 1 < j) ? _processes[i + 1] : null);
			}
			
			_diagram.update();
			
			if (bitmapData) _context3d.drawToBitmapData(bitmapData);
			if (present) _context3d.present();
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