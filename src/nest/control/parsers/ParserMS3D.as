package nest.control.parsers 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.object.data.*;
	import nest.object.geom.Quaternion;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	import nest.object.Mesh;
	
	/**
	 * ParserMS3D
	 */
	public class ParserMS3D {
		
		public function ParserMS3D() {
			
		}
		
		public function parse(model:ByteArray, scale:Number = 1):IMesh {
			var numVts:int;
			
			var i:int, j:int, k:int, l:int, m:int, n:int;
			
			var id:String = "";
			
			var v1:Vector3D = new Vector3D();
			var v2:Vector3D = new Vector3D();
			
			var vt1:Vertex, vt2:Vertex, vt3:Vertex, vt4:Vertex;
			var tri1:Triangle, tri2:Triangle;
			var rawVertex:Vector.<Vertex>;
			var rawTriangle:Vector.<Triangle>;
			
			model.endian = Endian.LITTLE_ENDIAN;
			model.position = 0;
			
			// header
			for (i = 0; i < 10; i++) id += String.fromCharCode(model.readUnsignedByte());
			if (id != "MS3D000000") throw new Error("Error reading MS3D file: Not a valid MS3D file");
			if (model.readInt() != 4) throw new Error("Error reading MS3D file: Bad version");
			
			// vertices
			// numVertices
			numVts = model.readUnsignedShort();
			rawVertex = new Vector.<Vertex>(numVts, true);
			for (i = 0; i < numVts; i++) {
				// flag
				if (model.readUnsignedByte() != 2) {
					// vert pos x,y,z
					vt1 = rawVertex[i] = new Vertex(model.readFloat() * scale, model.readFloat() * scale, model.readFloat() * scale);
					// bone, -1 no bone
					k = model.readByte();
					// refCount
					model.position++;
				}
			}
			
			// triangles
			// numTriangles
			j = model.readUnsignedShort();
			rawTriangle = new Vector.<Triangle>(j, true);
			for (i = 0; i < j; i++) {
				if (model.readUnsignedShort() != 2) {
					// tri indices v0, v1, v2
					tri1 = rawTriangle[i] = new Triangle(model.readUnsignedShort(), model.readUnsignedShort(), model.readUnsignedShort());
					vt1 = rawVertex[tri1.index0];
					vt2 = rawVertex[tri1.index1];
					vt3 = rawVertex[tri1.index2];
					// vertex normal
					vt1.normal.setTo(model.readFloat(), model.readFloat(), model.readFloat());
					vt2.normal.setTo(model.readFloat(), model.readFloat(), model.readFloat());
					vt3.normal.setTo(model.readFloat(), model.readFloat(), model.readFloat());
					// calculate triangle normal
					v1.setTo(vt2.x - vt1.x, vt2.y - vt1.y, vt2.z - vt1.z);
					v2.setTo(vt3.x - vt2.x, vt3.y - vt2.y, vt3.z - vt2.z);
					tri1.normal.copyFrom(v1.crossProduct(v2));
					tri1.normal.normalize();
					// vertex uv
					tri1.u0 = vt1.u = model.readFloat();
					tri1.u1 = vt2.u = model.readFloat();
					tri1.u2 = vt3.u = model.readFloat();
					tri1.v0 = vt1.v = model.readFloat();
					tri1.v1 = vt2.v = model.readFloat();
					tri1.v2 = vt3.v = model.readFloat();
					// smoothGroup
					model.position++;
					// groupIndex
					model.position++;
				}
			}
			
			model.position = 0;
			return new Mesh(new MeshData(rawVertex, rawTriangle), null, null);
		}
		
	}

}