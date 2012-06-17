package nest.view.lights 
{
	
	/**
	 * Light
	 */
	public interface ILight {
		
		function get next():ILight;
		function set next(value:ILight):void;
		
		function get color():uint;
		function get rgba():Vector.<Number>;
		
		function get active():Boolean;
		function set active(value:Boolean):void;
		
	}
	
}