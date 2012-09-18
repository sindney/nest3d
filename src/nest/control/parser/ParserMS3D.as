package nest.control.parser 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.object.geom.MeshData;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.Mesh;
	
	/**
	 * ParserMS3D
	 */
	public class ParserMS3D {
		
		private var _objects:Vector.<Mesh>;
		
		public function ParserMS3D() {
			
		}
		
		public function getObjectByName(name:String):Mesh {
			var object:Mesh;
			for each(object in _objects) {
				if (object.name == name) return object;
			}
			return null;
		}
		
		public function parse(model:ByteArray, scale:Number = 1):void {
			_objects = new Vector.<Mesh>();
			
			var numVts:int;
			
			var i:int, j:int, k:int, l:int, m:int, n:int;
			
			var name:String = "";
			
			var v1:Vector3D = new Vector3D();
			var v2:Vector3D = new Vector3D();
			
			var vt1:Vertex, vt2:Vertex, vt3:Vertex, vt4:Vertex;
			var triangle:Triangle;
			var rawVertices:Vector.<Vertex>;
			var rawTriangles:Vector.<Triangle>;
			var rawVertex:Vector.<Vertex>;
			var rawTriangle:Vector.<Triangle>;
			var rawIndices:Vector.<int>;
			var mesh:Mesh;
			
			model.endian = Endian.LITTLE_ENDIAN;
			model.position = 0;
			
			// header
			for (i = 0; i < 10; i++) name += String.fromCharCode(model.readUnsignedByte());
			if (name != "MS3D000000") throw new Error("Error reading MS3D file: Not a valid MS3D file");
			if (model.readInt() != 4) throw new Error("Error reading MS3D file: Bad version");
			
			// vertices
			// numVertices
			numVts = model.readUnsignedShort();
			rawVertices = new Vector.<Vertex>(numVts, true);
			for (i = 0; i < numVts; i++) {
				// flag
				if (model.readUnsignedByte() != 2) {
					// vert pos x,y,z
					vt1 = rawVertices[i] = new Vertex(model.readFloat() * scale, model.readFloat() * scale, model.readFloat() * scale);
					// bone, -1 no bone
					k = model.readByte();
					// refCount
					model.position++;
				}
			}
			
			// triangles
			// numTriangles
			j = model.readUnsignedShort();
			rawTriangles = new Vector.<Triangle>(j, true);
			for (i = 0; i < j; i++) {
				if (model.readUnsignedShort() != 2) {
					// tri indices v0, v1, v2
					triangle = rawTriangles[i] = new Triangle(model.readUnsignedShort(), model.readUnsignedShort(), model.readUnsignedShort());
					vt1 = rawVertices[triangle.index0];
					vt2 = rawVertices[triangle.index1];
					vt3 = rawVertices[triangle.index2];
					// vertex normal
					vt1.normal.setTo(model.readFloat(), model.readFloat(), model.readFloat());
					vt2.normal.setTo(model.readFloat(), model.readFloat(), model.readFloat());
					vt3.normal.setTo(model.readFloat(), model.readFloat(), model.readFloat());
					// calculate triangle normal
					v1.setTo(vt2.x - vt1.x, vt2.y - vt1.y, vt2.z - vt1.z);
					v2.setTo(vt3.x - vt2.x, vt3.y - vt2.y, vt3.z - vt2.z);
					triangle.normal.copyFrom(v1.crossProduct(v2));
					triangle.normal.normalize();
					// vertex uv
					triangle.u0 = vt1.u = model.readFloat();
					triangle.u1 = vt2.u = model.readFloat();
					triangle.u2 = vt3.u = model.readFloat();
					triangle.v0 = vt1.v = model.readFloat();
					triangle.v1 = vt2.v = model.readFloat();
					triangle.v2 = vt3.v = model.readFloat();
					// smoothGroup
					model.position++;
					// groupIndex
					model.position++;
				}
			}
			
			// groups
			// numGroups
			rawIndices = new Vector.<int>(numVts, true);
			j = model.readUnsignedShort();
			for (i = 0; i < j; i++) {
				for (k = 0; k < numVts; k++) {
					rawIndices[k] = -1;
				}
				rawVertex = new Vector.<Vertex>();
				rawTriangle = new Vector.<Triangle>();
				// flags
				model.position++;
				// name
				name = "";
				for (k = 0; k < 32; k++) {
					l = model.readUnsignedByte();
					if (l == 0) {
						continue;
					} else {
						name += String.fromCharCode(l);
					}
				}
				// numTriangles
				n = 0;
				l = model.readUnsignedShort();
				for (k = 0; k < l; k++) {
					m = model.readUnsignedShort();
					triangle = rawTriangles[m];
					if (rawIndices[triangle.index0] == -1) {
						rawVertex.push(rawVertices[triangle.index0]);
						rawIndices[triangle.index0] = triangle.index0 = n++;
					} else {
						triangle.index0 = rawIndices[triangle.index0];
					}
					if (rawIndices[triangle.index1] == -1) {
						rawVertex.push(rawVertices[triangle.index1]);
						rawIndices[triangle.index1] = triangle.index1 = n++;
					} else {
						triangle.index1 = rawIndices[triangle.index1];
					}
					if (rawIndices[triangle.index2] == -1) {
						rawVertex.push(rawVertices[triangle.index2]);
						rawIndices[triangle.index2] = triangle.index2 = n++;
					} else {
						triangle.index2 = rawIndices[triangle.index2];
					}
					rawTriangle.push(triangle);
				}
				// materialIndex
				model.position++;
				mesh = new Mesh(new MeshData(rawVertex, rawTriangle), null, null);
				mesh.name = name;
				_objects.push(mesh);
			}
			
			model.position = 0;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get objects():Vector.<Mesh> {
			return _objects;
		}
	}

}