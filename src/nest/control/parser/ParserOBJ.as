package nest.control.parser 
{
	import flash.utils.ByteArray;
	
	import nest.object.geom.Geometry;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	
	/**
	 * ParserOBJ
	 */
	public class ParserOBJ {
		
		private const LINE_END:String = String.fromCharCode(10);
		private const SPACE:String = String.fromCharCode(32);
		private const BLANK:String = "";
		private const BLANK1:String = " ";
		private const SLASH:String = "/";
		private const VERTEX:String = "v";
		private const NORMAL:String = "vn";
		private const UV:String = "vt";
		private const INDEX:String = "f";
		
		public function ParserOBJ() {
			
		}
		
		public function parse(model:ByteArray):Geometry {
			var vertices:Vector.<Number> = new Vector.<Number>();
			var normals:Vector.<Number> = new Vector.<Number>();
			var uvs:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();
			
			var rawVertex:Vector.<Vertex> = new Vector.<Vertex>();
			var rawTriangle:Vector.<Triangle> = new Vector.<Triangle>();
			
			var source:String = model.readUTFBytes(model.bytesAvailable);
			var lines:Array = source.split(LINE_END);
			var i:int, j:int, k:int, l:int, m:int;
			
			var start:int;
			var triplet:String;
			var words:Array, data:Array, subdata:Array;
			
			j = lines.length;
			for (i = 0; i < j; i++) {
				words = lines[i].split(SPACE);
				if (words.length > 0) {
					data = words.slice(1);
				} else {
					continue;
				}
				
				switch(words[0]) {
					case VERTEX:
						if (data[0] == BLANK || data[0] == BLANK1) data = data.slice(1);
						vertices.push(Number(data[0]), Number(data[1]), Number(data[2]));
						break;
					case NORMAL:
						if (data[0] == BLANK || data[0] == BLANK1) data = data.slice(1);
						normals.push(Number(data[0]), Number(data[1]), Number(data[2]));
						break;
					case UV:
						if (data[0] == BLANK || data[0] == BLANK1) data = data.slice(1);
						uvs.push(Number(data[0]), Number(data[1]));
						break;
					case INDEX:
						start = 0;
						while (data[start] == BLANK || data[start] == BLANK1) start++;
						l = start + 3;
						for (k = start; k < l; ++k) {
							triplet = data[k];
							subdata = triplet.split(SLASH);
							indices.push(subdata[0], subdata[1], subdata[2]);
						}
						break;
				}
			}
			
			var tri:Triangle;
			var vt:Vertex;
			var vt1:Vertex, vt2:Vertex, vt3:Vertex;
			
			j = vertices.length;
			for (i = 0; i < j; i += 3) {
				rawVertex[i / 3] = new Vertex(vertices[i], vertices[i + 1], vertices[i + 2]);
			}
			
			j = indices.length;
			for (i = 0; i < j; i += 9) {
				tri = rawTriangle[i / 9] = new Triangle(indices[i] - 1, indices[i + 3] - 1, indices[i + 6] - 1);
				
				for (k = 0; k < 3; k++) {
					vt = rawVertex[tri.indices[k]];
					
					m = k * 2;
					l = (indices[i + 1 + k * 3] - 1) * 2;
					tri.uvs[m] = vt.u = uvs[l];
					tri.uvs[m + 1] = vt.v = 1 - uvs[l + 1];
					
					l = (indices[i + 2 + k * 3] - 1) * 3;
					vt.nx = normals[l];
					vt.ny = normals[l + 1];
					vt.nz = normals[l + 2];
				}
			}
			
			return new Geometry(rawVertex, rawTriangle);
		}
		
	}

}