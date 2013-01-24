package nest.view.material 
{
	import flash.display3D.Program3D;
	
	import nest.control.animation.IAnimatable;
	import nest.object.IMesh;
	
	/**
	 * Material Interface.
	 */
	public interface IMaterial extends IAnimatable {
		
		function upload(mesh:IMesh):void;
		function unload():void;
		
		function comply():void;
		
		function dispose():void;
		
		function get program():Program3D;
		
		function get uv():Boolean;
		
		function get normal():Boolean;
		
	}
	
}