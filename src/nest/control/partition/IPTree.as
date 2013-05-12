package nest.control.partition 
{	
	
	/**
	 * IPTree
	 */
	public interface IPTree {
		
		function dispose():void;
		
		function get root():IPNode;
		
		function get frustum():Boolean;
		function set frustum(value:Boolean):void;
		
	}
	
}