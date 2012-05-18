package nest.view.materials 
{
	import flash.display3D.Context3D;
	
	/**
	 * Material Interface.
	 */
	public interface IMaterial {
		
		function upload(context3D:Context3D):void;
		function unload(context3D:Context3D):void;
		
	}
	
}