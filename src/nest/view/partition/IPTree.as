package nest.view.partition 
{	
	/**
	 * IPTree
	 */
	public interface IPTree {
		
		function create(data:Object):void;
		
		function get root():IPNode;
		
	}
	
}