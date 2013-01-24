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