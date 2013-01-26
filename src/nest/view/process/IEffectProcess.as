package nest.view.process 
{	
	import flash.display3D.textures.TextureBase;
	
	/**
	 * IEffectProcess
	 */
	public interface IEffectProcess extends IRenderProcess {
		
		function comply():void;
		
		function resize(width:int, height:int):void;
		
		function get textures():Vector.<TextureBase>;
		
		function get renderTarget():RenderTarget;
		
	}
	
}