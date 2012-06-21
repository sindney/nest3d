package nest.control.parsers 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.object.data.*;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	import nest.object.Mesh;
	
	/**
	 * ParserMS3D
	 */
	public class ParserMS3D {
		
		private var _objects:Vector.<IMesh>;
		
		public function ParserMS3D() {
			
		}
		
		public function getObjectByName(name:String):IMesh {
			var object:IMesh;
			for each(object in _objects) {
				if ((object as Mesh).name == name) return object;
			}
			return null;
		}
		
		public function parse(model:ByteArray, scale:Number = 1):void {
			_objects = new Vector.<IMesh>();
			
			var i:int, j:int, k:int, l:int, m:int, n:int;
			
			var id:String = "";
			
			var v1:Vector3D = new Vector3D();
			var v2:Vector3D = new Vector3D();
			
			var vt1:Vertex, vt2:Vertex, vt3:Vertex, vt4:Vertex;
			var tri1:Triangle, tri2:Triangle;
			var vertBoneId:Vector.<int>;
			var rawVertices:Vector.<Vertex>;
			var rawTriangles:Vector.<Triangle>;
			var rawVertex:Vector.<Vertex>;
			var rawTriangle:Vector.<Triangle>;
			var rawVtSign:Array;
			
			var meshData:MeshData;
			
			model.endian = Endian.LITTLE_ENDIAN;
			model.position = 0;
			
			// header
			for (i = 0; i < 10; i++) id += String.fromCharCode(model.readUnsignedByte());
			if (id != "MS3D000000") throw new Error("Error reading MS3D file: Not a valid MS3D file");
			if (model.readInt() != 4) throw new Error("Error reading MS3D file: Bad version");
			
			// vertices
			// numVertices
			j = model.readUnsignedShort();
			rawVertices = new Vector.<Vertex>(j, true);
			for (i = 0; i < j; i++) {
				// flag
				if (model.readUnsignedByte() != 2) {
					// vert pos x,y,z
					vt1 = rawVertices[i] = new Vertex(model.readFloat() * scale, model.readFloat() * scale, model.readFloat() * scale);
					// bone, -1 no bone
					k = model.readByte();
					if (k != -1) {
						/*vt1.linker = new JointLinker();
						if (!vertBoneId) vertBoneId = new Vector.<int>(j, true);
						vertBoneId[i] = k;*/
					}
					// refCount
					model.readUnsignedByte();
				}
			}
			
			// triangles
			// numTriangles
			j = model.readUnsignedShort();
			rawTriangles = new Vector.<Triangle>(j, true);
			for (i = 0; i < j; i++) {
				if (model.readUnsignedShort() != 2) {
					// tri indices v0, v1, v2
					tri1 = rawTriangles[i] = new Triangle(model.readUnsignedShort(), model.readUnsignedShort(), model.readUnsignedShort());
					vt1 = rawVertices[tri1.index0];
					vt2 = rawVertices[tri1.index1];
					vt3 = rawVertices[tri1.index2];
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
					vt1.u = model.readFloat();
					vt2.u = model.readFloat();
					vt3.u = model.readFloat();
					vt1.v = model.readFloat();
					vt2.v = model.readFloat();
					vt3.v = model.readFloat();
					// smoothGroup
					model.readUnsignedByte();
					// groupIndex
					model.readUnsignedByte();
				}
			}
			
			// groups
			// numGroups
			j = model.readUnsignedShort();
			_objects = new Vector.<IMesh>(j, true);
			for (i = 0; i < j; i++) {
				if (model.readUnsignedByte() != 2) {
					// name of the mesh
					id = "";
					for (k = 0; k < 32; k++) id += String.fromCharCode(model.readUnsignedByte());
					// numTriangles
					n = 0;
					k = model.readUnsignedShort();
					rawVtSign = new Array();
					rawVertex = new Vector.<Vertex>();
					rawTriangle = new Vector.<Triangle>(k, true);
					for (l = 0; l < k; l++) {
						tri1 = rawTriangles[model.readUnsignedShort()];
						vt1 = rawVertices[tri1.index0];
						vt2 = rawVertices[tri1.index1];
						vt3 = rawVertices[tri1.index2];
						
						tri2 = rawTriangle[l] = new Triangle();
						tri2.normal.copyFrom(tri1.normal);
						
						m = rawVtSign[tri1.index0];
						if (m) {
							tri2.index0 += m;
						} else {
							tri2.index0 = rawVtSign[tri1.index0] = n;
							vt4 = rawVertex[n] = new Vertex(vt1.x, vt1.y, vt1.z, vt1.u, vt1.v);
							vt4.normal.copyFrom(vt1.normal);
							n++;
						}
						
						m = rawVtSign[tri1.index1];
						if (m) {
							tri2.index1 += m;
						} else {
							tri2.index1 = rawVtSign[tri1.index1] = n;
							vt4 = rawVertex[n] = new Vertex(vt2.x, vt2.y, vt2.z, vt2.u, vt2.v);
							vt4.normal.copyFrom(vt2.normal);
							n++;
						}
						
						m = rawVtSign[tri1.index2];
						if (m) {
							tri2.index2 += m;
						} else {
							tri2.index2 = rawVtSign[tri1.index2] = n;
							vt4 = rawVertex[n] = new Vertex(vt3.x, vt3.y, vt3.z, vt3.u, vt3.v);
							vt4.normal.copyFrom(vt3.normal);
							n++;
						}
					}
					
					meshData = new MeshData(rawVertex, rawTriangle);
					_objects[i] = new Mesh(meshData, null, null);
					(_objects[i] as Mesh).name = id;
					// material index
					model.readUnsignedByte();
				}
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get objects():Vector.<IMesh> {
			return _objects;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.control.parsers.ParserMS3D]";
		}
		
	}

}