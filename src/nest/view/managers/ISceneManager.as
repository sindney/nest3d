package nest.view.managers 
{
	import flash.display3D.Context3D;
	
	import nest.object.IContainer3D;
	import nest.view.Camera3D;
	
	/**
	 * ISceneManager
	 */
	public interface ISceneManager {
		
		function calculate():void;
		
		function get camera():Camera3D;
		function set camera(value:Camera3D):void;
		
		function get root():IContainer3D;
		function set root(value:IContainer3D):void;
		
		function get context3D():Context3D;
		function set context3D(value:Context3D):void;
		
		function get numVertices():int;
		function get numTriangles():int;
		function get numObjects():int;
		
	}
	
}