package nest.control.animation 
{
	
	/**
	 * IKeyFrame
	 */
	public interface IKeyFrame {
		
		function clone():IKeyFrame;
		
		function dispose():void;
		
		function get time():Number;
		function set time(value:Number):void;
		
		function get name():String;
		function set name(value:String):void;
		
	}
	
}