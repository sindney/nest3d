package nest.object.geom
{
	
	/**
	 * Geometry
	 */
	public class Geometry {
		
		public static const VERTEX:String = "vertex";
		public static const UV:String = "uv";
		public static const NORMAL:String = "normal";
		
		private var _vertexBuffers:Vector.<VertexBuffer3DProxy> = new Vector.<VertexBuffer3DProxy>();
		private var _indexBuffers:Vector.<IndexBuffer3DProxy> = new Vector.<IndexBuffer3DProxy>();
		
		public var numVertices:int = 0;
		public var numIndices:int = 0;
		public var numTriangles:int = 0;
		
		public var vertices:Vector.<Vertex>;
		public var triangles:Vector.<Triangle>;
		
		public function Geometry(vertices:Vector.<Vertex>, triangles:Vector.<Triangle>) {
			this.vertices = vertices;
			this.triangles = triangles;
		}
		
		public function dispose():void {
			for each(var vb:VertexBuffer3DProxy in _vertexBuffers) {
				if (vb.buffer) {
					vb.buffer.dispose();
					vb.buffer = null;
				}
			}
			for each(var ib:IndexBuffer3DProxy in _indexBuffers) {
				if (ib.buffer) {
					ib.buffer.dispose();
					ib.buffer = null;
				}
			}
			_vertexBuffers = null;
			_indexBuffers = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get vertexBuffers():Vector.<VertexBuffer3DProxy> {
			return _vertexBuffers;
		}
		
		public function get indexBuffers():Vector.<IndexBuffer3DProxy> {
			return _indexBuffers;
		}
		
	}

}