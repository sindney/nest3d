package nest.view.process 
{
	import flash.geom.Matrix3D;
	
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	
	/**
	 * IContainerProcess
	 */
	public interface IContainerProcess extends IRenderProcess {
		
		function get container():IContainer3D;
		function set container(value:IContainer3D):void;
		
		function get meshProcess():IMeshProcess;
		function set meshProcess(value:IMeshProcess):void;
		
		function get objects():Vector.<IMesh>;
		
		function get excludedObjects():Vector.<IMesh>;
		
		function get ivm():Matrix3D;
		function get pm():Matrix3D;
		
		function get color():uint;
		function set color(value:uint):void;
		
		function get numVertices():int;
		function get numTriangles():int;
		function get numObjects():int;
		
	}
	
}