package nest.control.controller 
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	/**
	 * MouseEvent3D
	 */
	public class MouseEvent3D extends Event {
		
		public static const MOUSE_DOWN:String = "mouseDown";
		public static const MOUSE_OVER:String = "mouseOver";
		public static const MOUSE_MOVE:String = "mouseMove";
		public static const MOUSE_OUT:String = "mouseOut";
		public static const MOUSE_UP:String = "mouseUp";
		public static const CLICK:String = "click";
		public static const RIGHT_CLICK:String = "rightClick";
		public static const RIGHT_MOUSE_DOWN:String = "rightMouseDown";
		public static const RIGHT_MOUSE_UP:String = "rightMouseUp";
		
		public function MouseEvent3D(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var copy:MouseEvent3D = new MouseEvent3D(type, bubbles, cancelable);
			return copy;
		}
	}

}