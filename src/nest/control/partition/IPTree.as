package nest.control.partition 
{	
	import nest.object.IObject3D;
	/**
	 * IPTree
	 */
	public interface IPTree {
		
		function get nonMeshes():Vector.<IObject3D>;
		function get root():IPNode;
		
	}
	
}