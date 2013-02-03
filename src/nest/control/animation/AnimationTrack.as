package nest.control.animation 
{
	/**
	 * AnimationTrack
	 * <p>This track will run when controller's time is greater than track.start.</p>
	 * <p>And the type of KeyFrames must be the same.</p>
	 */
	public class AnimationTrack {
		
		public var name:String;
		
		public var length:Number = 0;
		
		/**
		 * The start time(sec) for this track.
		 */
		public var start:Number = 0;
		
		public var first:IKeyFrame;
		
		public var last:IKeyFrame;
		
		/**
		 * Track modifier's type depends on the type of your KeyFrames.
		 */
		public var modifier:IAnimationModifier;
		
		public function AnimationTrack(name:String = "") {
			this.name = name;
		}
		
		public function addChild(frame:IKeyFrame):void {
			if (!first) {
				first = last = frame;
				length = frame.time;
			} else {
				last.next = frame;
				last = frame;
				length = frame.time;
			}
			frame.next = null;
		}
		
		public function removeChild(frame:IKeyFrame):void {
			if (frame == first) {
				first = first.next;
				if (!first) {
					last = null;
					length = 0;
				} else {
					length = first.time;
				}
				return;
			}
			var cur:IKeyFrame = first;
			while (cur) {
				if (cur.next == frame) {
					cur.next = frame.next;
					frame.next = null;
					length = cur.time;
					if (last == frame) {
						last = cur;
					}
					return;
				}
				cur = cur.next;
			}
		}
		
	}

}