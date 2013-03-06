package nest.control.animation 
{
	
	/**
	 * IAnimationModifier
	 */
	public interface IAnimationModifier {
		
		function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void;
		
	}
	
}