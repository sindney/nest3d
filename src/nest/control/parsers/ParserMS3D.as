package nest.control.parsers 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.object.data.*;
	import nest.object.geom.Joint;
	import nest.object.geom.Quaternion;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	import nest.object.Mesh;
	import nest.object.SkinnedMesh;
	
	/**
	 * ParserMS3D
	 */
	public class ParserMS3D {
		
		public function ParserMS3D() {
			
		}
		
		public function parse(model:ByteArray, scale:Number = 1, fps:Number = 30):IMesh {
			var numVts:int;
			var animation:Boolean = false;
			
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
					if (k != -1) {
						animation = true;
						vt1.joints[0] = k;
					}
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
			
			if (!animation) {
				model.position = 0;
				return new Mesh(new MeshData(rawVertex, rawTriangle), null, null);
			}
			
			// groups
			// numGroups
			if ( model.readUnsignedShort() != 1) throw new Error("Error reading MS3D file: Bad group number");
			// flag
			model.position++;
			// name of the mesh
			model.position += 32;
			// numTriangles, triangle indices
			i = model.readUnsignedShort();
			model.position += i * 2;
			// materialIndex
			model.position++;
			
			var joint1:Joint, joint2:Joint, joint3:Joint, joint4:Joint;
			var frame1:KeyFrame, frame2:KeyFrame;
			var rawJointParent:Vector.<String>;
			var rawJoint:Vector.<Joint>;
			
			// numMaterials times material struct
			i = model.readUnsignedShort();
			model.position += i * 361;
			// animation fps, currentTime, totalFrames
			model.position += 12;
			
			// numJoints
			j = model.readUnsignedShort();
			rawJoint = new Vector.<Joint>(j, true);
			rawJointParent = new Vector.<String>(j, true);
			for (i = 0; i < j; i++) {
				if (model.readUnsignedByte() != 2) {
					// name of the joint
					id = "";
					for (k = 0; k < 32; k++) id += String.fromCharCode(model.readUnsignedByte());
					joint1 = rawJoint[i] = new Joint();
					joint1.name = id;
					// parent name
					id = "";
					for (k = 0; k < 32; k++) id += String.fromCharCode(model.readUnsignedByte());
					rawJointParent[i] = id;
					// local transforms
					v1.setTo(model.readFloat(), model.readFloat(), model.readFloat());
					v2.setTo(model.readFloat(), model.readFloat(), model.readFloat());
					joint1.offset.identity();
					joint1.offset.appendRotation(v1.x, Vector3D.X_AXIS);
					joint1.offset.appendRotation(v1.y, Vector3D.Y_AXIS);
					joint1.offset.appendRotation(v1.z, Vector3D.Z_AXIS);
					joint1.offset.appendTranslation(v2.x, v2.y, v2.z);
					// numRotationKeyFrames
					k = model.readUnsignedShort();
					// numPositionKeyFrames
					l = model.readUnsignedShort();
					// rotation keyFrames
					frame1 = joint1.rotation = new KeyFrame(KeyFrame.ROTATION);
					frame1.time = 0;
					frame1.component.w = 1;
					for (m = 0; m < k; m++) {
						frame2 = new KeyFrame(KeyFrame.ROTATION);
						frame2.time = model.readFloat() * fps;
						Quaternion.rotationXYZ(frame2.component, model.readFloat(), model.readFloat(), model.readFloat());
						frame1.next = frame2;
						frame1 = frame2;
					}
					frame1 = joint1.position = new KeyFrame(KeyFrame.POSITION);
					frame1.time = 0;
					// position keyFrames
					for (m = 0; m < k; m++) {
						frame2 = new KeyFrame(KeyFrame.POSITION);
						frame2.time = model.readFloat() * fps;
						frame2.component.setTo(model.readFloat(), model.readFloat(), model.readFloat());
						frame1.next = frame2;
						frame1 = frame2;
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
			
			// number of joint1 comments
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
			l = 1 / (k == 2 ? 100 : 255);
			for (i = 0; i < numVts; i++) {
				vt1 = rawVertex[i];
				vt1.joints[1] = model.readByte();
				vt1.joints[2] = model.readByte();
				vt1.joints[3] = model.readByte();
				m = model.readByte();
				vt1.weights[0] = m > 0 ? m * l : 1;
				m = model.readByte();
				if (vt1.joints[1] != -1) vt1.weights[1] = m * l;
				m = model.readByte();
				if (vt1.joints[2] != -1) vt1.weights[2] = m * l;
				if (vt1.joints[3] != -1) vt1.weights[3] = 1 - vt1.weights[0] - vt1.weights[1] - vt1.weights[2];
				if (k == 2) model.position += 4;
			}
			
			var skin:SkinnedMesh = new SkinnedMesh(new MeshData(rawVertex, rawTriangle), null, null);
			skin.joints = rawJoint;
			skin.vertices = new Vector.<Number>(numVts * 3, true);
			for (i = 0; i < numVts; i++) {
				j = i * 3;
				vt1 = rawVertex[i];
				skin.vertices[j] = vt1.x;
				skin.vertices[j + 1] = vt1.y;
				skin.vertices[j + 2] = vt1.z;
			}
			
			j = rawJoint.length;
			for (i = 0; i < j; i++) {
				id = rawJointParent[i];
				joint1 = rawJoint[i];
				l = 0;
				for (k = 0; k < j; k++) {
					if (k == i) continue;
					joint2 = rawJoint[k];
					if (joint2.name == id) {
						if (joint2.firstChild) {
							joint3 = joint2.firstChild;
							while (joint3) {
								joint4 = joint3;
								joint3 = joint3.sibling;
							}
							joint4.sibling = joint1;
						} else {
							joint2.firstChild = joint1;
						}
						l = 1;
						break;
					}
				}
				if (l == 0) skin.joint = joint1;
			}
			
			model.position = 0;
			return skin;
		}
		
	}

}