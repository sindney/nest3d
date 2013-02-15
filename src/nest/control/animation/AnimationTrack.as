package nest.control.animation 
{
	/**
	 * AnimationTrack
	 */
	public class AnimationTrack {
		
		public var name:String;
		
		public var length:Number = 0;
		
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
		
		public function clone():AnimationTrack {
			var result:AnimationTrack = new AnimationTrack();

			var key0:IKeyFrame = first;
			var key1:IKeyFrame;
			while (key0) {
				if (key1) {
					key1.next = key0.clone();
					key1 = key1.next;
				} else {
					result.first = key1 = key0.clone();
				}
				key0 = key0.next;
			}
			result.last = key1;

			result.name = name;
			result.length = length;
			result.loops = loops;
			result.speed = speed;
			result.position = position;
			result.enabled = enabled;
			result.weight = weight;
			result.modifier = modifier;

			return result;
		}

	}

}