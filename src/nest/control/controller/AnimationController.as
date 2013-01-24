package nest.control.controller 
{
	import flash.utils.getTimer;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.IAnimatable;
	
	/**
	 * AnimationController
	 */
	public class AnimationController {
		
		private var _time:Number = 0;
		private var _last:int = -1;
		private var _loop:uint = 0;
		
		public var objects:Vector.<IAnimatable> = new Vector.<IAnimatable>();
		public var paused:Boolean = true;
		public var speed:Number = 1;
		public var loops:uint = 0;
		
		public function AnimationController() {
			
		}
		
		public function update():void {
			var l:int = targets.length;
			if (paused || l < 1) return;
			
			var curTime:int = getTimer();
			var dt:Number = (curTime - _last) / 1000;
			
			_last = curTime;
			_time += dt * speed;
			l = length;
			
			if (_time > l) {
				_time -= l;
				_loop++;
				if (_loop > loops) paused = true;
			}
			
			var object:IAnimatable;
			var track:AnimationTrack;
			for each(object in objects) {
				for each(track in object.tracks) {
					if (track.length > 0) {
						track.first.calculate(object, track.first, _time);
					}
				}
			}
		}
		
		public function restart():void {
			paused = false;
			_current = 0;
			_last = getTimer();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(value:Number):void {
			_time = value;
			_last = getTimer();
		}
		
		public function get length():Number {
			var i:Number = 0;
			var object:IAnimatable;
			var track:AnimationTrack;
			for each(object in objects) {
				for each(track in object.tracks) {
					if (track.length > i) i = track.length;
				}
			}
			return i;
		}
		
	}

}