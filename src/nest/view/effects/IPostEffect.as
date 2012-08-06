package nest.view.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	
	/**
	 * IPostEffect
	 */
	public interface IPostEffect {
		
		function createTexture(width:Number, height:Number):void;
		function calculate():void;
		function dispose():void;
		
		function get texture():TextureBase;
		
		function get enableDepthAndStencil():Boolean;
		
		function get next():IPostEffect;
		function set next(value:IPostEffect):void;
		
		function get context3d():Context3D;
		function set context3d(value:Context3D):void;
		
	}
	
}