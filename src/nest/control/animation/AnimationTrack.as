package nest.control.animation 
{
	import flash.utils.Dictionary;
	
	import nest.object.IMesh;
	
	/**
	 * AnimationTrack
	 */
	public class AnimationTrack {
		
		public var name:String;
		
		public var frames:Vector.<IKeyFrame>;
		
		public var modifier:IAnimationModifier;
		
		public var target:IMesh;
		
		public var parameters:Dictionary = new Dictionary();
		
		public var loops:int = 0;
		
		public var position:Number = 0;
		
		public var weight:Number = 1;
		
		public var enabled:Boolean = true;
		
		public function AnimationTrack(frames:Vector.<IKeyFrame>) {
			this.frames = frames;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get length():Number {
			var i:int = frames ? frames.length : 0;
			return i > 0 ? frames[i - 1].time : 0;
		}
		
	}
}