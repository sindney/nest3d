package nest.control.util
{	
	import nest.object.Geometry;
	
	/**
	 * Primitives
	 */
	public final class Primitives {
		
		public static function createSkybox():Geometry {
			var geom:Geometry = new Geometry();
			geom.vertices = new Vector.<Number>();
			geom.vertices.push(-.5, .5, -.5, .5, .5, -.5, 
								.5, -.5, -.5, -.5, -.5, -.5, 
								.5, .5, .5, -.5, .5, .5, 
								-.5, -.5, .5, .5, -.5, .5);
			geom.indices = new Vector.<uint>();
			geom.indices.push(0, 3, 2, 0, 2, 1, 
							4, 7, 6, 4, 6, 5, 
							5, 0, 1, 5, 1, 4, 
							7, 2, 3, 7, 3, 6, 
							5, 6, 3, 5, 3, 0, 
							1, 2, 7, 1, 7, 4);
			geom.vertices.fixed = geom.indices.fixed = true;
			return geom;
		}
		
		public static function createPlane():Geometry {
			var geom:Geometry = new Geometry();
			geom.vertices = new Vector.<Number>();
			geom.vertices.push( -.5, .5, 0, .5, .5, 0, 
								.5, -.5, 0, -.5, -.5, 0);
			geom.uvs = new Vector.<Number>();
			geom.uvs.push(0, 0, 1, 0, 1, 1, 0, 1);
			geom.indices = new Vector.<uint>();
			geom.indices.push(0, 1, 2, 2, 3, 0);
			geom.vertices.fixed = geom.uvs.fixed = geom.indices.fixed = true;
			return geom;
		}
		
		public static function createBox():Geometry {
			var geom:Geometry = new Geometry();
			geom.vertices = new Vector.<Number>();
			geom.vertices.push( -.5, .5, -.5, 
								.5, .5, -.5, 
								.5, -.5, -.5, 
								-.5, -.5, -.5, 
								-.5, .5, .5, 
								.5, .5, .5, 
								.5, -.5, .5, 
								-.5, -.5, .5);
			geom.indices = new Vector.<uint>();
			geom.indices.push(0, 1, 2, 2, 3, 0, 
							5, 4, 7, 7, 6, 5,
							4, 5, 1, 1, 0, 4, 
							6, 7, 3, 3, 2, 6, 
							1, 5, 6, 6, 2, 1, 
							4, 0, 3, 3, 7, 4);
			geom.vertices.fixed = geom.indices.fixed = true;
			return geom;
		}
		
	}

}