package nest.control.animation 
{
	
	/**
	 * IAnimatable
	 */
	public interface IAnimatable {
		
		function get tracks():Vector.<AnimationTrack>;
		function set tracks(value:Vector.<AnimationTrack>):void;
		
	}
	
}