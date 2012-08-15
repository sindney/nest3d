package nest.view.managers 
{
	import nest.object.IMesh;
	import nest.view.culls.ICulling;
	import nest.view.processes.IProcess;
	
	/**
	 * ISceneManager
	 */
	public interface ISceneManager {
		
		function calculate():void;
		
		function get culling():ICulling;
		function set culling(value:ICulling):void;
		
		function get process():IProcess;
		function set process(value:IProcess):void;
		
		function get first():Boolean;
		function set first(value:Boolean):void;
		
		function get objects():Vector.<IMesh>;
		
		function get numVertices():int;
		function get numTriangles():int;
		function get numObjects():int;
		
	}
	
}