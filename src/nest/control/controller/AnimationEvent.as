package nest.control.controller 
{
	import flash.events.Event;
	
	/**
	 * AnimationEvent
	 */
	public class AnimationEvent extends Event {
		
		public static const LOOP_COMPLETE:String = "loopComplete";
		public static const LOOPS_COMPLETE:String = "loopsComplete";
		
		public function AnimationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var copy:AnimationEvent = new AnimationEvent(type, bubbles, cancelable);
			return copy;
		}
		
	}

}