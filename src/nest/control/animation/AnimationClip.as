package nest.control.animation 
{
	import flash.utils.getTimer;
	import nest.object.AnimatedMesh;
	
	/**
	 * AnimationClip
	 */
	public class AnimationClip 
	{
		public var target:AnimatedMesh;
		
		public var tracks:Vector.<AnimationTrack>;
		private var _paused:Boolean;
		private var _time:Number = -1;
		private var _lastTime:int = -1;
		
		private var _length:Number = -1;
		private var _currentLoop:uint = 0;
		
		public var speed:Number = 1;
		public var loops:uint=0;
		
		public function AnimationClip() 
		{
			tracks = new Vector.<AnimationTrack>();
			time = 0;
		}
		
		public function play():void {
			_paused = false;
			_currentLoop = 0;
			_lastTime = getTimer();
		}
		
		public function pause():void {
			_paused = true;
		}
		
		public function update():void {
			if (_paused) return;
			var curTime:int = getTimer();
			var dt:Number = (curTime-_lastTime)/1000;
			_lastTime = curTime;
			_time += dt * speed;
			if (_time > _length) {
				_time-= _length;
				_currentLoop++;
				if (_currentLoop>loops) {
					pause();
				}
			}
			var t:Number = _time;
			var frame:KeyFrame;
			var weight1:Number;
			var weight2:Number;
			var l:uint, i:int;
			for each(var track:AnimationTrack in tracks) {
				frame = track.frameList;
				while (t>frame.time) {
					t -= frame.time;
					frame = frame.next;
				}
				if (frame) {
					if (frame.next) {
						weight2 = t / frame.time;
						weight1 = 1 - weight2;
						if (frame is VertexKeyFrame) {
							var curVertices:Vector.<Number> = (frame as VertexKeyFrame).vertices;
							var nextVertices:Vector.<Number> = (frame.next as VertexKeyFrame).vertices;
							l = curVertices.length/3;
							for (i = 0; i < l;i++ ) {
								target.data.vertices[i].x = curVertices[i * 3] * weight1 + nextVertices[i * 3] * weight2;
								target.data.vertices[i].y = curVertices[i * 3 + 1] * weight1 + nextVertices[i * 3 + 1] * weight2;
								target.data.vertices[i].z = curVertices[i * 3 + 2] * weight1 + nextVertices[i * 3 + 2] * weight2;
							}
						}
					}else {
						if (frame is VertexKeyFrame) {
							curVertices = (frame as VertexKeyFrame).vertices;
							l = curVertices.length/3;
							for (i = 0; i < l;i++ ) {
								target.data.vertices[i].x = curVertices[i * 3];
								target.data.vertices[i].y = curVertices[i * 3 + 1];
								target.data.vertices[i].z = curVertices[i * 3 + 2];
							}
						}
					}
				}
			}
			target.data.update(true);
		}
		
		public function clone():AnimationClip {
			var result:AnimationClip = new AnimationClip();
			var l:uint = tracks.length;
			var copyTracks:Vector.<AnimationTrack> = new Vector.<AnimationTrack>(l);
			for (var i:int = 0; i < l;i++ ) {
				copyTracks[i] = tracks[i].clone();
			}
			result.tracks = copyTracks;
			return result;
		}
		
		public function addTrack(track:AnimationTrack):void {
			tracks.push(track);
			if (track.length>_length) {
				_length = track.length;
			}
		}
		
		public function removeTrack(track:AnimationTrack):void {
			var index:int = tracks.indexOf(track);
			var l:uint = tracks.length-1;
			if (index!=-1) {
				if (index!=l) {
					tracks[index] = tracks.pop();
				}else {
					tracks.pop();
				}
			}
			_length = -1;
			for each(var tempTrack:AnimationTrack in tracks) {
				if (tempTrack.length>_length) {
					_length = tempTrack.length;
				}
			}
		}
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(value:Number):void {
			_time = value;
			_lastTime = getTimer();
		}
		
		public function get length():Number {
			return _length;
		}
		
	}

}