package nest.view.process 
{
	import flash.display3D.textures.TextureBase;
	
	/**
	 * IRenderProcess
	 */
	public interface IRenderProcess {
		
		function calculate(next:IRenderProcess):void;
		
		function dispose():void;
		
		function get texture():TextureBase;
		function set texture(value:TextureBase):void;
		
		function get enableDepthAndStencil():Boolean;
		function set enableDepthAndStencil(value:Boolean):void;
		
		function get antiAlias():int;
		function set antiAlias(value:int):void;
		
		function get clear():Boolean;
		function set clear(value:Boolean):void;
		
	}
	
}