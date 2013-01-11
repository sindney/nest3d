package nest.view.process 
{
	import flash.geom.Matrix3D;
	
	import nest.object.IMesh;
	
	/**
	 * IMeshProcess
	 */
	public interface IMeshProcess {
		
		function initialize():void;
		
		function calculate(mesh:IMesh, ivm:Matrix3D, pm:Matrix3D):void;
		
	}
	
}