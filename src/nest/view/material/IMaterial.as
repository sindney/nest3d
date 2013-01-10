package nest.view.material 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	
	/**
	 * Material Interface.
	 */
	public interface IMaterial {
		
		function upload(context3d:Context3D):void;
		function unload(context3d:Context3D):void;
		
		function comply(context3d:Context3D):void;
		
		function dispose():void;
		
		function get program():Program3D;
		
		function get uv():Boolean;
		
		function get normal():Boolean;
		
	}
	
}