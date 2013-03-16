package nest.control.controller 
{
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.IKeyFrame;
	
	/**
	 * Dispatched when one loop is finished.
	 */
	[AnimationEvent(name = "loopComplete", type = "nest.control.controller.AnimationEvent")]
	
	/**
	 * Dispatched when all loops are finished.
	 */
	[AnimationEvent(name = "loopsComplete", type = "nest.control.controller.AnimationEvent")]
	
	/**
	 * AnimationController
	 */
	public class AnimationController extends EventDispatcher {
		
		private var _time:Number = 0;
		private var _length:Number = 0;
		private var _paused:Boolean = true;
		
		private var last:int = 0;
		private var count:int = 0;
		
		public var tracks:Vector.<AnimationTrack> = new Vector.<AnimationTrack>();
		public var speed:Number = 1;
		public var loops:int = 0;
		
		public function calculate():void {
			if (_paused) return;
			
			var ct:int = getTimer();
			var dt:Number = (ct - last) / 1000;
			
			last = ct;
			_time += dt * speed;
			
			if (_time > _length) {
				_time = 0;
				count++;
				dispatchEvent(new AnimationEvent(AnimationEvent.LOOP_COMPLETE));
				if (count >= loops) {
					_paused = true;
					dispatchEvent(new AnimationEvent(AnimationEvent.LOOPS_COMPLETE));
				}
			}
			
			var flag:Boolean;
			var i:int, j:int;
			var tt:Number;
			var track:AnimationTrack;
			var frame0:IKeyFrame, frame1:IKeyFrame;
			for each(track in tracks) {
				frame0 = frame1 = null;
				if (track.enabled && track.frames && _time >= track.position && (track.loops == int.MAX_VALUE || _time < track.position + track.length * (track.loops + 1))) {
					tt = _time - track.position;
					j = track.frames.length;
					flag = false;
					for (i = 0; i < j; i++) {
						frame1 = track.frames[i];
						if (frame1.time >= tt) {
							flag = true;
							break;
						}
					}
					if (flag) {
						frame0 = track.frames[i - 1];
						track.modifier.calculate(track, frame0, frame1, tt);
					}
				}
			}
		}
		
		/**
		 * Call this when tracks array is changed.
		 */
		public function setup():void {
			var i:Number, j:Number = 0;
			for each(var track:AnimationTrack in tracks) {
				if (track.enabled && track.frames) {
					if (track.loops == int.MAX_VALUE) {
						j = Number.MAX_VALUE;
						break;
					}
					i = track.position + track.length * (track.loops + 1);
					if (i > j) j = i;
				}
			}
			_length = j;
		}
		
		public function restart():void {
			_paused = false;
			_time = 0;
			count = 0;
			last = getTimer();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(value:Number):void {
			_time = value;
			last = getTimer();
		}
		
		public function get length():Number {
			return _length;
		}
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function set paused(value:Boolean):void {
			_paused = value;
			if (!_paused) last = getTimer();
		}
		
	}

}