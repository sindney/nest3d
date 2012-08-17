package nest.view.effects 
{
	import flash.display3D.textures.TextureBase;
	
	/**
	 * IPostEffect
	 */
	public interface IPostEffect {
		
		function calculate():void;
		function dispose():void;
		
		function get textures():Vector.<TextureBase>;
		
		function get enableDepthAndStencil():Boolean;
		
		function get antiAlias():int;
		function set antiAlias(value:int):void;
		
		function get next():IPostEffect;
		function set next(value:IPostEffect):void;
		
	}
	
}