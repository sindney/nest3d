package nest.control.animation 
{
	import nest.object.IMesh;
		
	/**
	 * IAnimationModifier
	 */
	public interface IAnimationModifier {
		
		function calculate(target:IMesh, k1:IKeyFrame, k2:IKeyFrame, time:Number, weight:Number):void;
		
	}
	
}