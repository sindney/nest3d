package nest.control.animation 
{
	import nest.object.IMesh;
		
	/**
	 * IAnimationModifier
	 */
	public interface IAnimationModifier {
		
		function calculate(target:IMesh, root:IKeyFrame, time:Number):void;
		
	}
	
}