package nest.view.process 
{	
	import nest.object.geom.Geometry;
	
	/**
	 * IEffectProcess
	 */
	public interface IEffectProcess extends IRenderProcess {
		
		function comply():void;
		
		function get geom():Geometry;
		function set geom(value:Geometry):void;
		
	}
	
}