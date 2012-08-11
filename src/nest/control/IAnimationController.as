package nest.control 
{
	
	/**
	 * IAnimationController
	 */
	public interface IAnimationController {
		
		function get paused():Boolean;
		function set paused(value:Boolean):void;
		
		function get time():Number;
		function set time(value:Number):void;
		
		function get advanceTime():Number;
		function set advanceTime(value:Number):void;
		
	}
	
}