package nest.control.util
{	
	import nest.object.geom.Geometry;
	import nest.object.geom.Vertex;
	import nest.object.geom.Triangle;
	
	/**
	 * Primitives
	 */
	public final class Primitives {
		
		private static var _skybox:Geometry;
		
		public static function get skybox():Geometry {
			if (!_skybox) {
				var vertices:Vector.<Vertex> = new Vector.<Vertex>();
				var triangles:Vector.<Triangle> = new Vector.<Triangle>();
				
				vertices.push(new Vertex( -.5, .5, -.5), 
								new Vertex(.5, .5, -.5), 
								new Vertex(.5, -.5, -.5), 
								new Vertex( -.5, -.5, -.5), 
								new Vertex(.5, .5, .5), 
								new Vertex( -.5, .5, .5), 
								new Vertex( -.5, -.5, .5), 
								new Vertex(.5, -.5, .5));
				
				triangles.push(new Triangle(0, 3, 2), 
								new Triangle(0, 2, 1), 
								new Triangle(4, 7, 6), 
								new Triangle(4, 6, 5), 
								new Triangle(5, 0, 1), 
								new Triangle(5, 1, 4), 
								new Triangle(7, 2, 3), 
								new Triangle(7, 3, 6), 
								new Triangle(5, 6, 3), 
								new Triangle(5, 3, 0), 
								new Triangle(1, 2, 7), 
								new Triangle(1, 7, 4));
				
				vertices.fixed = triangles.fixed = true;
				
				Geometry.calculateNormal(vertices, triangles);
				_skybox = new Geometry(vertices, triangles);
			}
			return _skybox;
		}
		
		private static var _plane:Geometry;
		
		public static function get plane():Geometry {
			if (!_plane) {
				var vertices:Vector.<Vertex> = new Vector.<Vertex>();
				var triangles:Vector.<Triangle> = new Vector.<Triangle>();
				
				vertices.push(new Vertex( -0.5, -0.5, 0, 0, 0), 
								new Vertex(0.5, -0.5, 0, 1, 0), 
								new Vertex(0.5, 0.5, 0, 1, 1), 
								new Vertex( -0.5, 0.5, 0, 0, 1));
				
				triangles.push(new Triangle(0, 2, 1, 0, 1, 1, 0, 1, 1), 
								new Triangle(0, 3, 2, 0, 1, 0, 0, 1, 0));
				
				vertices.fixed = triangles.fixed = true;
				
				Geometry.calculateNormal(vertices, triangles);
				_plane = new Geometry(vertices, triangles);
			}
			return _plane;
		}
		
		private static var _box:Geometry;
		
		public static function get box():Geometry {
			if (!_box) {
				var vertices:Vector.<Vertex> = new Vector.<Vertex>();
				var triangles:Vector.<Triangle> = new Vector.<Triangle>();
				
				vertices.push(new Vertex( -0.5, 0.5, -0.5, 0, 0), 
								new Vertex(0.5, 0.5, -0.5, 1, 0), 
								new Vertex(0.5, -0.5, -0.5, 1, 1), 
								new Vertex( -0.5, -0.5, -0.5, 0, 1), 
								new Vertex(0.5, 0.5, 0.5, 0, 0), 
								new Vertex( -0.5, 0.5, 0.5, 1, 0), 
								new Vertex( -0.5, -0.5, 0.5, 1, 1), 
								new Vertex(0.5, -0.5, 0.5, 0, 1));
				
				triangles.push(new Triangle(0, 1, 2, 0, 0, 1, 0, 1, 1), 
								new Triangle(0, 2, 3, 0, 0, 1, 1, 0, 1), 
								new Triangle(4, 5, 6, 0, 0, 1, 0, 1, 1), 
								new Triangle(4, 6, 7, 0, 0, 1, 1, 0, 1), 
								new Triangle(5, 4, 1, 0, 0, 1, 0, 1, 1), 
								new Triangle(5, 1, 0, 0, 0, 1, 1, 0, 1), 
								new Triangle(7, 6, 3, 0, 0, 1, 0, 1, 1), 
								new Triangle(7, 3, 2, 0, 0, 1, 1, 0, 1), 
								new Triangle(5, 0, 3, 0, 0, 1, 0, 1, 1), 
								new Triangle(5, 3, 6, 0, 0, 1, 1, 0, 1), 
								new Triangle(1, 4, 7, 0, 0, 1, 0, 1, 1), 
								new Triangle(1, 7, 2, 0, 0, 1, 1, 0, 1));
				
				vertices.fixed = triangles.fixed = true;
				
				Geometry.calculateNormal(vertices, triangles);
				_box = new Geometry(vertices, triangles);
			}
			return _box;
		}
		
	}

}