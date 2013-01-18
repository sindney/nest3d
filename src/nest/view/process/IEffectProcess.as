package nest.view.process 
{	
	import flash.display3D.textures.TextureBase;
	
	/**
	 * IEffectProcess
	 */
	public interface IEffectProcess extends IRenderProcess {
		
		function comply():void;
		
		function resize(width:Number, height:Number):void;
		
		function get textures():Vector.<TextureBase>;
		
	}
	
}