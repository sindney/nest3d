package nest.object 
{
	import nest.view.shader.IConstantShaderPart;
	
	/**
	 * IParticlePart
	 */
	public interface IParticlePart {
		
		function dispose():void;
		
		function get constantsPart():Vector.<IConstantShaderPart>;
		
	}
	
}