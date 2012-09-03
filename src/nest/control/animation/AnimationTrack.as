package nest.control.animation 
{
	/**
	 * AnimationTrack
	 */
	public class AnimationTrack {
		
		public var name:String;
		
		public var length:Number=0;
		
		public var frameList:KeyFrame;
		
		public var lastFrame:KeyFrame;
		
		public function AnimationTrack(name:String="") {
			this.name = name;
		}
		
		public function addFrame(frame:KeyFrame):void {
			if (!frameList) {
				frameList = lastFrame = frame;
				length += frame.time;
			}else {
				lastFrame.next = frame;
				lastFrame = frame;
				length += frame.time;
			}
		}
		
		public function removeFrame(frame:KeyFrame):void {
			if (frame==frameList) {
				frameList = frameList.next;
				length -= frame.time;
				if (!frameList) {
					lastFrame = null;
				}
				return;
			}
			var cur:KeyFrame=frameList;
			while (cur) {
				if (cur.next==frame) {
					cur.next = frame.next;
					frame.next = null;
					length -= frame.time;
					if (lastFrame==frame) {
						lastFrame = cur;
					}
					return;
				}
				cur = cur.next;
			}
		}
		
		public function clone():AnimationTrack {
			var result:AnimationTrack = new AnimationTrack();
			result.name = name;
			result.length = length;
			
			var prev:KeyFrame = frameList.clone();
			var next:KeyFrame;
			var frame:KeyFrame = frameList.next;
			result.frameList = prev;
			while (frame) {
				next=frame.clone();
				prev.next = next;
				prev = next;
				frame = frame.next;
			}
			result.lastFrame = next;
			return result;
		}
		
	}

}