package nest.object 
{
	import flash.display.BitmapData;
	import nest.control.factories.PrimitiveFactory;
	import nest.object.data.MeshData;
	import nest.object.geom.IBound;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.view.materials.IMaterial;
	import nest.view.materials.MovieMaterial;
	
	/**
	 * Sprite3D
	 */
	public class Sprite3D extends Mesh 
	{
		private static var _meshData:MeshData;
		private var _width:Number;
		private var _height:Number;
		public function Sprite3D(material:IMaterial, width:Number = 100, height:Number = 100, bound:IBound = null)
		{
			super(Sprite3D.meshData,material,bound);
			this.width = width;
			this.height = height;
		}
		public static function get meshData():MeshData {
			if (!_meshData) {
				var vertices:Vector.<Vertex> = Vector.<Vertex>([new Vertex( -0.5, -0.5, 0, 0.0, 0.0), 
																new Vertex(0.5, -0.5, 0, 1.0, 0.0), 
																new Vertex(0.5, 0.5, 0, 1.0, 1.0), 
																new Vertex( -0.5, 0.5, 0, 0.0, 1.0)]);
				var tris:Vector.<Triangle> = new Vector.<Triangle>(2,true);
				var tri:Triangle = new Triangle(0, 2, 1);
				tri.u0 = 0.0; tri.v0 = 1.0;
				tri.u1 = 1.0; tri.v1 = 0.0;
				tri.u2 = 1.0; tri.v2 = 1.0;
				tris[0] = tri;
				tri = new Triangle(0, 3, 2);
				tri.u0 = 0.0; tri.v0 = 1.0;
				tri.u1 = 0.0; tri.v1 = 0.0;
				tri.u2 = 1.0; tri.v2 = 0.0;
				tris[1] = tri;
				_meshData = new MeshData(vertices, tris);
			}
			return _meshData;
		}
		public function get width():Number {
			return _width;
		}
		public function set width(value:Number):void {
			scale.x = value;
			_width = value;
			_changed = true;
		}
		public function get height():Number {
			return _height;
		}
		public function set height(value:Number):void {
			scale.y = value;
			_height = value;
			_changed = true;
		}
	}

}