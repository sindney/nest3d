package nest.control.animation 
{
	
	/**
	 * IKeyFrame
	 */
	public interface IKeyFrame {
		
		function clone():IKeyFrame;
		
		function get time():Number;
		function set time(value:Number):void;
		
		function get name():String;
		function set name(value:String):void;
		
		function get next():IKeyFrame;
		function set next(value:IKeyFrame):void;
		
	}
	
}