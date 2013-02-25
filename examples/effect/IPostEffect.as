package effect 
{
	import flash.display3D.textures.TextureBase;
	import nest.view.process.IRenderProcess;
	
	/**
	 * IPostEffect
	 */
	public interface IPostEffect extends IRenderProcess {
		
		function get texture():TextureBase;
		
	}
	
}