package nest.view.light 
{
	
	/**
	 * Light
	 */
	public interface ILight {
		
		function get next():ILight;
		function set next(value:ILight):void;
		
		function get color():uint;
		function get rgba():Vector.<Number>;
		
	}
	
}