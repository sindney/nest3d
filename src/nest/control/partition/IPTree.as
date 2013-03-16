package nest.control.partition 
{	
	
	/**
	 * IPTree
	 */
	public interface IPTree {
		
		function get root():IPNode;
		
		function get frustum():Boolean;
		function set frustum(value:Boolean):void;
		
	}
	
}