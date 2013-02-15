package nest.control.animation 
{
	import nest.object.IMesh;
		
	/**
	 * IAnimationModifier
	 */
	public interface IAnimationModifier {
		
		function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame;
		function calculate(target:IMesh, root:IKeyFrame, time:Number):void;
		
	}
	
}