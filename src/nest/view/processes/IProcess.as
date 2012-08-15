package nest.view.processes 
{
	import nest.object.IMesh;
	
	/**
	 * IProcess
	 */
	public interface IProcess {
		
		function doMesh(mesh:IMesh):void;
		
	}
	
}