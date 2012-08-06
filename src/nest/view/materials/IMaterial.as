package nest.view.materials 
{
	import flash.display3D.Context3D;
	
	/**
	 * Material Interface.
	 */
	public interface IMaterial {
		
		function upload(context3d:Context3D):void;
		function unload(context3d:Context3D):void;
		
		function get uv():Boolean;
		
	}
	
}