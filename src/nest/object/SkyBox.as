package nest.object 
{
	import flash.display.BitmapData;
	
	import nest.object.data.MeshData;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.view.materials.IMaterial;
	import nest.view.materials.SkyBoxMaterial;
	
	/**
	 * SkyBox
	 */
	public class SkyBox extends Mesh {
		
		private var size:Number = 0;
		
		public function SkyBox(size:Number, material:SkyBoxMaterial) {
			this.size = size;
			
			var s2:Number = size / 2;
			var tri:Triangle;
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(8, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(12, true);
			
			vertices[0] = new Vertex( -s2, s2, -s2);
			vertices[1] = new Vertex(s2, s2, -s2);
			vertices[2] = new Vertex(s2, -s2, -s2);
			vertices[3] = new Vertex( -s2, -s2, -s2);
			
			vertices[4] = new Vertex(s2, s2, s2);
			vertices[5] = new Vertex( -s2, s2, s2);
			vertices[6] = new Vertex( -s2, -s2, s2);
			vertices[7] = new Vertex(s2, -s2, s2);
			
			// front
			tri = triangles[0] = new Triangle(0, 3, 2);
			tri = triangles[1] = new Triangle(0, 2, 1);
			
			// back
			tri = triangles[2] = new Triangle(4, 7, 6);
			tri = triangles[3] = new Triangle(4, 6, 5);
			
			// top
			tri = triangles[4] = new Triangle(5, 0, 1);
			tri = triangles[5] = new Triangle(5, 1, 4);
			
			// bottom
			tri = triangles[6] = new Triangle(7, 2, 3);
			tri = triangles[7] = new Triangle(7, 3, 6);
			
			// left
			tri = triangles[8] = new Triangle(5, 6, 3);
			tri = triangles[9] = new Triangle(5, 3, 0);
			
			// right
			tri = triangles[10] = new Triangle(1, 2, 7);
			tri = triangles[11] = new Triangle(1, 7, 4);
			
			MeshData.calculateNormal(vertices, triangles);
			var data:MeshData = new MeshData(vertices, triangles);
			
			super(data, material);
		}
		
		override public function clone():IMesh {
			var result:SkyBox = new SkyBox(size, material as SkyBoxMaterial);
			result.blendMode.source = _blendMode.source;
			result.blendMode.dest = _blendMode.dest;
			result.blendMode.depthMask = _blendMode.depthMask;
			result.cliping = _cliping;
			result.culling = _culling;
			result.visible = _visible;
			result.alphaTest = _alphaTest;
			return result;
		}
		
	}

}