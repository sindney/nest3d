package nest.control.controller 
{
	import flash.utils.getTimer;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.IKeyFrame;
	
	/**
	 * AnimationController
	 */
	public class AnimationController {
		
		private var _time:Number = 0;
		private var _length:Number = 0;
		
		private var last:int = 0;
		private var count:int = 0;
		
		public var tracks:Vector.<AnimationTrack> = new Vector.<AnimationTrack>();
		public var paused:Boolean = true;
		public var speed:Number = 1;
		public var loops:int = 0;
		
		public function calculate():void {
			if (paused) return;
			
			var ct:int = getTimer();
			var dt:Number = (ct - last) / 1000;
			
			last = ct;
			_time += dt * speed;
			
			if (_time > _length) {
				_time = 0;
				count++;
				if (count >= loops) paused = true;
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
						track.modifier.calculate(track.target, frame0, frame1, tt, track.weight);
					}
				}
			}
		}
		
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
			paused = false;
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
		
	}

}