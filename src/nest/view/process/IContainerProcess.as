package nest.view.process 
{
	import flash.geom.Matrix3D;
	
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.view.shader.IConstantShaderPart;
	import nest.view.Camera3D;
	
	/**
	 * IContainerProcess
	 */
	public interface IContainerProcess extends IRenderProcess {
		
		function get constantsPart():Vector.<IConstantShaderPart>;
		function set constantsPart(value:Vector.<IConstantShaderPart>):void;
		
		function get container():IContainer3D;
		function set container(value:IContainer3D):void;
		
		function get objects():Vector.<IMesh>;
		
		function get alphaObjects():Vector.<IMesh>;
		
		function get camera():Camera3D;
		function set camera(value:Camera3D):void;
		
		function get numVertices():int;
		function get numTriangles():int;
		function get numObjects():int;
		
	}
	
}