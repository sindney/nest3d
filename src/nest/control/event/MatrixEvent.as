package nest.control.event 
{
	import flash.events.Event;
	
	/**
	 * MatrixEvent
	 */
	public class MatrixEvent extends Event {
		
		public static const TRANSFORM_CHANGE:String = "transform_change";
		
		public function MatrixEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var copy:MatrixEvent = new MatrixEvent(type, bubbles, cancelable);
			return copy;
		}
		
	}

}