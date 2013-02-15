package nest.control.animation 
{
	/**
	 * AnimationSet
	 */
	public class AnimationSet {
		
		public var name:String;
		
		public var track:AnimationTrack;

		public var target:IMesh;

		public var loops:int = 0;
		
		public var position:Number = 0;

		public var enabled:Boolean = true;

		public var weight:Number = 1;

	}
}