package nest.control.animation 
{
	
	/**
	 * IAnimatable
	 * <p>If you want to animate a class, then implement this.</p>
	 */
	public interface IAnimatable {
		
		function get tracks():Vector.<AnimationTrack>;
		function set tracks(value:Vector.<AnimationTrack>):void;
		
	}
	
}