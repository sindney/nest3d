package nest.control.controller 
{
	import flash.utils.getTimer;
	
	import nest.control.animation.ANimationSet;
	
	/**
	 * AnimationController
	 */
	public class AnimationController {
		
		private var _time:Number = 0;
		
		private var last:int = 0;
		private var count:int = 0;
		
		public var objects:Vector.<AnimationSet> = new Vector.<AnimationSet>();
		public var paused:Boolean = true;
		public var speed:Number = 1;
		public var loops:int = 0;
		
		public function AnimationController() {
			
		}
		
		public function calculate():void {
			if (paused) return;
			
			var ct:int = getTimer();
			var dt:Number = (ct - last) / 1000;
			
			last = ct;
			_time += dt * speed;
			
			if (_time > length) {
				_time = 0;
				count++;
				if (count >= loops) paused = true;
			}
			
			var object:AnimationSet;
			for each(object in objects) {
				if (_time >= object.track.position && _time < object.position + object.track.length * track.loops) {
					object.track.modifier.calculate(object.target, object.track.first, _time - track.start);
				}
			}
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
			var i:Number = 0;
			var object:IAnimatable;
			var track:AnimationTrack;
			for each(object in objects) {
				if (!object.tracks) continue;
				for each(track in object.tracks) {
					if (track.length + track.start > i) i = track.length + track.start;
				}
			}
			return i;
		}
		
	}

}