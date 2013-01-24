package nest.control.animation 
{
	
	/**
	 * IKeyFrame
	 */
	public interface IKeyFrame {
		
		function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame;
		function calculate(target:IAnimatable, root:IKeyFrame, time:Number):void;
		
		function get time():Number;
		function set time(value:Number):void;
		
		function get name():String;
		function set name(value:String):void;
		
		function get next():IKeyFrame;
		function set next(value:IKeyFrame):void;
		
	}
	
}