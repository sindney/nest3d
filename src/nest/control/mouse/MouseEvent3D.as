package nest.control.mouse 
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	/**
	 * MouseEvent3D
	 */
	public class MouseEvent3D extends Event {
		
		public static const MOUSE_DOWN:String = "mouse_down";
		public static const MOUSE_OVER:String = "mouse_over";
		public static const MOUSE_MOVE:String = "mouse_move";
		public static const MOUSE_OUT:String = "mouse_out";
		public static const CLICK:String = "click";
		public static const DOUBLE_CLICK:String = "double_click";
		
		public var position:Vector3D = new Vector3D();
		
		public function MouseEvent3D(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var copy:MouseEvent3D = new MouseEvent3D(type, bubbles, cancelable);
			copy.position.copyFrom(position);
			return copy;
		}
	}

}