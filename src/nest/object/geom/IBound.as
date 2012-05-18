package nest.object.geom 
{
	import flash.geom.Vector3D;
	
	import nest.object.geom.Vertex;
	
	/**
	 * IBound
	 */
	public interface IBound {
		
		function update(vertices:Vector.<Vertex>):void;
		
		function get center():Vector3D;
		
	}
	
}