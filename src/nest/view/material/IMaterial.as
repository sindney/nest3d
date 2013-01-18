package nest.view.material 
{
	import flash.display3D.Program3D;
	
	import nest.object.IMesh;
	
	/**
	 * Material Interface.
	 */
	public interface IMaterial {
		
		function upload(mesh:IMesh):void;
		function unload():void;
		
		function comply():void;
		
		function dispose():void;
		
		function get program():Program3D;
		
		function get uv():Boolean;
		
		function get normal():Boolean;
		
	}
	
}