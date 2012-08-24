package nest.view.materials 
{
	import flash.display3D.Context3D;
	import nest.view.Shader3D;
	
	/**
	 * Material Interface.
	 */
	public interface IMaterial {
		
		function upload(context3d:Context3D):void;
		function unload(context3d:Context3D):void;
		
		/**
		 * Update material's shader.
		 */
		function update():void;
		
		function get uv():Boolean;
		
		function get shader():Shader3D;
		
	}
	
}