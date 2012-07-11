package nest.control.parsers 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.object.data.*;
	import nest.object.geom.Joint;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	import nest.object.Mesh;
	import nest.object.SkinnedMesh;
	
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
			
			var numVts:int;
			var animation:Boolean = false;
			var skeletalAnimation:Boolean = false;
			
			var i:int, j:int, k:int, l:int, m:int, n:int;
			
			var id:String = "";
			
			var v1:Vector3D = new Vector3D();
			var v2:Vector3D = new Vector3D();
			
			var vt1:Vertex, vt2:Vertex, vt3:Vertex, vt4:Vertex;
			var tri1:Triangle, tri2:Triangle;
			var rawVtBone:Vector.<Boolean>;
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
			numVts = model.readUnsignedShort();
			rawVtBone = new Vector.<Boolean>(j, true);
			rawVertices = new Vector.<Vertex>(j, true);
			for (i = 0; i < numVts; i++) {
				// flag
				if (model.readUnsignedByte() != 2) {
					// vert pos x,y,z
					vt1 = rawVertices[i] = new Vertex(model.readFloat() * scale, model.readFloat() * scale, model.readFloat() * scale);
					// bone, -1 no bone
					k = model.readByte();
					rawVtBone[i] = false;
					if (k != -1) {
						skeletalAnimation = true;
						rawVtBone[i] = true;
						vt1.joints[0] = k;
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
					tri1.u0 = vt1.u = model.readFloat();
					tri1.u1 = vt2.u = model.readFloat();
					tri1.u2 = vt3.u = model.readFloat();
					tri1.v0 = vt1.v = model.readFloat();
					tri1.v1 = vt2.v = model.readFloat();
					tri1.v2 = vt3.v = model.readFloat();
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
					animation = false;
					rawVtSign = new Array();
					rawVertex = new Vector.<Vertex>();
					rawTriangle = new Vector.<Triangle>(k, true);
					for (l = 0; l < k; l++) {
						tri1 = rawTriangles[model.readUnsignedShort()];
						
						tri2 = rawTriangle[l] = new Triangle();
						tri2.normal.copyFrom(tri1.normal);
						tri2.u0 = tri1.u0;
						tri2.u1 = tri1.u1;
						tri2.u2 = tri1.u2;
						tri2.v0 = tri1.v0;
						tri2.v1 = tri1.v1;
						tri2.v2 = tri1.v2;
						
						if (rawVtBone[tri1.index0] || rawVtBone[tri1.index1] || rawVtBone[tri1.index2]) {
							animation = true;
							continue;
						}
						
						vt1 = rawVertices[tri1.index0];
						vt2 = rawVertices[tri1.index1];
						vt3 = rawVertices[tri1.index2];
						
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
					
					if (animation) {
						meshData = new MeshData(null, rawTriangle);
						_objects[i] = new SkinnedMesh(meshData, null, null);
					} else {
						meshData = new MeshData(rawVertex, rawTriangle);
						_objects[i] = new Mesh(meshData, null, null);
					}
					(_objects[i] as Mesh).name = id;
					// material index
					model.readUnsignedByte();
				}
			}
			
			if (!skeletalAnimation) return;
			
			var joint:Joint;
			var frame1:KeyFrame, frame2:KeyFrame;
			var rawJointParent:Vector.<String>;
			var rawJoints:Vector.<Joint>;
			
			// numMaterials times material struct
			model.position += model.readUnsignedShort() * 361;
			
			// animation fps, currentTime, totalFrames
			model.position += 12;
			
			// numJoints
			j = model.readUnsignedShort();
			rawJoints = new Vector.<Joint>(j, true);
			rawJointParent = new Vector.<String>(j, true);
			for (i = 0; i < j; i++) {
				if (model.readUnsignedByte() != 2) {
					// name of the joint
					id = "";
					for (k = 0; k < 32; k++) id += String.fromCharCode(model.readUnsignedByte());
					joint = rawJoints[i] = new Joint();
					joint.name = id;
					// parent name
					id = "";
					for (k = 0; k < 32; k++) id += String.fromCharCode(model.readUnsignedByte());
					rawJointParent[i] = id;
					// local transforms
					joint.local.appendRotation(model.readFloat(), Vector3D.X_AXIS);
					joint.local.appendRotation(model.readFloat(), Vector3D.Y_AXIS);
					joint.local.appendRotation(model.readFloat(), Vector3D.Z_AXIS);
					joint.local.appendTranslation(model.readFloat(), model.readFloat(), model.readFloat());
					// numRotationKeyFrames
					k = model.readUnsignedShort();
					// numPositionKeyFrames
					l = model.readUnsignedShort();
					// rotation keyFrames
					for (m = 0; m < k; m++) {
						frame2 = new KeyFrame(KeyFrame.ROTATION);
						frame2.time = model.readFloat();
						frame2.component.x = model.readFloat();
						frame2.component.y = model.readFloat();
						frame2.component.z = model.readFloat();
						if (frame1) {
							frame1.next = frame2;
							frame1 = frame2;
						} else {
							joint.rotation = frame1 = frame2;
						}
					}
					frame1 = null;
					// position keyFrames
					for (m = 0; m < k; m++) {
						frame2 = new KeyFrame(KeyFrame.POSITION);
						frame2.time = model.readFloat();
						frame2.component.x = model.readFloat();
						frame2.component.y = model.readFloat();
						frame2.component.z = model.readFloat();
						if (frame1) {
							frame1.next = frame2;
							frame1 = frame2;
						} else {
							joint.position = frame1 = frame2;
						}
					}
				}
			}
			
			// subVersion of the comments
			model.position += 4;
			// number of group comments
			k = model.readUnsignedInt();
			for (m = 0; m < k; m++) {
				// index
				model.position += 4;
				// commentLength
				n = model.readInt();
				model.position += n;
			}
			
			// number of material comments
			k = model.readUnsignedInt();
			for (m = 0; m < k; m++) {
				// index
				model.position += 4;
				// commentLength
				n = model.readInt();
				model.position += n;
			}
			
			// number of joint comments
			k = model.readUnsignedInt();
			for (m = 0; m < k; m++) {
				// index
				model.position += 4;
				// commentLength
				n = model.readInt();
				model.position += n;
			}
			
			// number of model comments 0/1
			k = model.readUnsignedInt();
			for (m = 0; m < k; m++) {
				// index
				model.position += 4;
				// commentLength
				n = model.readInt();
				model.position += n;
			}
			
			// subversion of the vertex extra information
			k = model.readInt();
			for (l = 0; l < numVts; l++) {
				vt1 = rawVertices[l];
				vt1.joints[1] = int(String.fromCharCode(model.readByte()));
				vt1.joints[2] = int(String.fromCharCode(model.readByte()));
				vt1.joints[3] = int(String.fromCharCode(model.readByte()));
				n = 0;
				m = model.readByte();
				if (vt1.joints[0] != -1) n += vt1.weights[0] = (m + 128) / 255;
				m = model.readByte();
				if (vt1.joints[1] != -1) n += vt1.weights[1] = (m + 128) / 255;
				m = model.readByte();
				if (vt1.joints[2] != -1) n += vt1.weights[2] = (m + 128) / 255;
				m = model.readByte();
				if (vt1.joints[3] != -1) vt1.weights[3] = 1 - n;
				if (k == 2) model.position += 4;
			}
			
			// TODO: 使用jointParent来连接joint tree
			
			// TODO: 遍历_objects数组，非SkinnedMesh跳过，SkinnedMesh根据其MeshData存储的triangles信息
			// 从rawVertices数组得到MeshData的vertices信息(更新过joint索引与权重)
			// 记得根据当前SkinnedMesh任意Joint得到根joint并附给SkinnedMesh.joint
			// 还要把所有出现的joint存入SkinnedMesh.joints，顺序要和joint索引一致
			
			model.position = 0;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get objects():Vector.<IMesh> {
			return _objects;
		}
		
	}

}