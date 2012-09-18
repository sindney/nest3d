package nest.view.process 
{
	import nest.object.IMesh;
	
	/**
	 * IProcess
	 */
	public interface IProcess {
		
		function doMesh(mesh:IMesh):void;
		
	}
	
}