package nest.view.process 
{
	import flash.geom.Matrix3D;
	
	import nest.object.IMesh;
	
	/**
	 * IMeshProcess
	 */
	public interface IMeshProcess {
		
		function calculate(mesh:IMesh, pm:Matrix3D):void;
		
	}
	
}