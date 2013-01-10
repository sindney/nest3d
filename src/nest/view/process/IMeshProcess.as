package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	
	import nest.object.IMesh;
	
	/**
	 * IMeshProcess
	 */
	public interface IMeshProcess {
		
		function initialize(context3d:Context3D):void;
		
		function calculate(context3d:Context3D, mesh:IMesh, ivm:Matrix3D, pm:Matrix3D):void;
		
	}
	
}