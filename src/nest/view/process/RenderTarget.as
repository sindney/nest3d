package nest.view.process 
{
	import flash.display3D.textures.TextureBase;
	
	/**
	 * RenderTarget
	 */
	public class RenderTarget {
		
		public var texture:TextureBase;
		public var enableDepthAndStencil:Boolean = true;
		public var antiAlias:int = 0;
		public var surfaceSelector:int = 0;
		
	}

}