package nest.control.parser
{
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.IKeyFrame;
	import nest.control.animation.JointKeyFrame;
	import nest.control.animation.JointModifier;
	import nest.object.geom.Geometry;
	import nest.object.geom.Joint;
	import nest.object.geom.SkinInfo;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	
	/**
	 * ParserMD5
	 * <p>Refer to Gaara's MD5Parser.</p>
	 */
	public class ParserMD5 {
		
		private const COMMENT_TOKEN:String = "//";
		private const VERSION_TOKEN:String = "MD5Version";
		private const COMMAND_TOKEN:String = "commandline";
		private const NUM_JOINTS_TOKEN:String = "numJoints";
		private const NUM_MESHES_TOKEN:String = "numMeshes";
		private const JOINTS_TOKEN:String = "joints";
		private const MESH_TOKEN:String = "mesh";
		private const MESH_SHADER_TOKEN:String = "shader";
		private const MESH_NUM_VERTS_TOKEN:String = "numverts";
		private const MESH_VERT_TOKEN:String = "vert";
		private const MESH_NUM_TRIS_TOKEN:String = "numtris";
		private const MESH_TRI_TOKEN:String = "tri";
		private const MESH_NUM_WEIGHTS_TOKEN:String = "numweights";
		private const MESH_WEIGHT_TOKEN:String = "weight";
		
		private const NUM_FRAMES_TOKEN:String = "numFrames";
		private const FRAME_RATE_TOKEN:String = "frameRate";
		private const NUM_ANIMATED_COMPONENTS_TOKEN:String = "numAnimatedComponents";
		private const HIERARCHY_TOKEN:String = "hierarchy";
		private const BOUNDS_TOKEN:String = "bounds";
		private const BASE_FRAME_TOKEN:String = "baseframe";
		private const FRAME_TOKEN:String = "frame";
		
		private var data:String;
		private var eof:Boolean;
		
		private var line:int;
		private var parseIndex:int;
		private var charLineIndex:int;
		
		public var skinInfo:SkinInfo;
		public var track:AnimationTrack;
		
		public function ParserMD5() {
			
		}
		
		public function dispose():void {
			data = null;
			skinInfo = null;
			track = null;
			jointInfo = null;
			baseFrame = null;
		}
		
		private var frameRate:int;
		private var num_frames:int;
		private var num_animatedComponents:int;
		private var jointInfo:Vector.<int>;
		private var baseFrame:Vector.<Number>;
		
		public function parseMD5Anim(anim:ByteArray):void {
			data = anim.readUTFBytes(anim.bytesAvailable);
			eof = false;
			parseIndex = 0;
			charLineIndex = 0;
			frameRate = 0;
			num_frames = 0;
			num_animatedComponents = 0;
			
			var i:int;
			var token:String;
			while (true) {
				token = getNextToken();
				switch(token) {
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case VERSION_TOKEN:
						if (parseInt(getNextToken()) != 10) throw new Error("Error reading MD5 file: Bad version");
						break;
					case COMMAND_TOKEN:
						ignoreLine();
						break;
					case NUM_FRAMES_TOKEN:
						num_frames = parseInt(getNextToken());
						track = new AnimationTrack(new Vector.<IKeyFrame>(num_frames));
						track.parameters[JointModifier.JOINT_POSITION] = true;
						track.parameters[JointModifier.JOINT_ROTATION] = true;
						track.parameters[JointModifier.JOINT_SCALE] = false;
						break;
					case NUM_JOINTS_TOKEN:
						num_joints = parseInt(getNextToken());
						break;
					case FRAME_RATE_TOKEN:
						frameRate = parseInt(getNextToken());
						break;
					case NUM_ANIMATED_COMPONENTS_TOKEN:
						num_animatedComponents = parseInt(getNextToken());
						break;
					case HIERARCHY_TOKEN:
						parseHierarchy();
						break;
					case BOUNDS_TOKEN:
						parseBounds();
						break;
					case BASE_FRAME_TOKEN:
						parseBaseFrame();
						break;
					case FRAME_TOKEN:
						parseFrame();
						break;
				}
				if (eof) break;
			}
		}
		
		private function parseHierarchy():void {
			var ch:String;
			var token:String = getNextToken();
			var i:int = 0;
			jointInfo = new Vector.<int>();
			do {
				parseLiteralString();
				// parent
				getNextInt()
				// flag, start index
				jointInfo.push(getNextInt(), getNextInt());
				ch = getNextChar();
				if (ch == "/") {
					putBack();
					ch = getNextToken();
					if (ch == COMMENT_TOKEN) ignoreLine();
					ch = getNextChar();
				}
				if (ch != "}") putBack();
			} while (ch != "}");
		}
		
		private function parseBounds():void {
			var ch:String;
			var token:String = getNextToken();
			var frame:JointKeyFrame;
			var vector3:Vector3D;
			var i:int = 0;
			do {
				frame = new JointKeyFrame();
				vector3 = parseVector3D();
				frame.bounds[0] = vector3.x;
				frame.bounds[1] = vector3.y;
				frame.bounds[2] = vector3.z;
				vector3 = parseVector3D();
				frame.bounds[3] = vector3.x;
				frame.bounds[4] = vector3.y;
				frame.bounds[5] = vector3.z;
				frame.time = i;
				track.frames[i++] = frame;
				ch = getNextChar();
				if (ch == "/") {
					putBack();
					ch = getNextToken();
					if (ch == COMMENT_TOKEN) ignoreLine();
					ch = getNextChar();
				}
				if (ch != "}") putBack();
			} while (ch != "}");
		}
		
		private function parseBaseFrame():void {
			var ch:String;
			var token:String = getNextToken();
			baseFrame = new Vector.<Number>();
			do {
				getNextToken();
				baseFrame.push(parseFloat(getNextToken()), parseFloat(getNextToken()), parseFloat(getNextToken()));
				getNextToken();
				getNextToken();
				baseFrame.push(parseFloat(getNextToken()), parseFloat(getNextToken()), parseFloat(getNextToken()));
				getNextToken();
				ch = getNextChar();
				if (ch == "/") {
					putBack();
					ch = getNextToken();
					if (ch == COMMENT_TOKEN) ignoreLine();
					ch = getNextChar();
				}
				if (ch != "}") putBack();
			} while (ch != "}");
		}
		
		private function parseFrame():void {
			var ch:String;
			var frame:JointKeyFrame = track.frames[parseInt(getNextToken())] as JointKeyFrame;
			var frameData:Vector.<Number>;
			var token:String = getNextToken();
			var i:int, j:int, k:int, l:int, flag:int, index:int;
			var t:Number, x:Number, y:Number, z:Number;
			do {
				frameData = new Vector.<Number>();
				for (i = 0; i < num_animatedComponents; i++) {
					frameData.push(parseFloat(getNextToken()));
				}
				// TODO: JointKeyFrame初始化这里需要修改
				frame = new JointKeyFrame();
				j = jointInfo.length;
				for (i = 0; i < j; i++) {
					baseFrameData = baseFrame[i];
					k = i * 2;
					flag = jointInfo[k];
					index = jointInfo[k + 1];
					l = i * 6, k = 0;
					frame.transforms[l + k] = (flag & 1) ? frameData[index + k] : baseFrame[l + k];
					k++;
					frame.transforms[l + k] = (flag & 2) ? frameData[index + k] : baseFrame[l + k];
					k++;
					frame.transforms[l + k] = (flag & 4) ? frameData[index + k] : baseFrame[l + k];
					k++;
					x = frame.transforms[l + k] = (flag & 8) ? frameData[index + k] : baseFrame[l + k];
					k++;
					y = frame.transforms[l + k] = (flag & 16) ? frameData[index + k] : baseFrame[l + k];
					k++;
					z = frame.transforms[l + k] = (flag & 32) ? frameData[index + k] : baseFrame[l + k];
					k++;
					t = 1 - (x * x) - (y * y) - (z * z);
					frame.transforms[l + k] = t < 0 ? 0 : -Math.sqrt(t);
				}
				ch = getNextChar();
				if (ch == "/") {
					putBack();
					ch = getNextToken();
					if (ch == COMMENT_TOKEN) ignoreLine();
					ch = getNextChar();
				}
				if (ch != "}") putBack();
			} while (ch != "}");
		}
		
		private var num_joints:int;
		private var num_meshes:int;
		
		public function parseMD5Mesh(model:ByteArray):void {
			data = model.readUTFBytes(model.bytesAvailable);
			eof = false;
			line = 0;
			parseIndex = 0;
			charLineIndex = 0;
			num_joints = 0;
			num_meshes = 0;
			
			var token:String;
			while(true){
				token = getNextToken();
				switch(token) {
					case COMMENT_TOKEN:
						ignoreLine();		
						break;
					case VERSION_TOKEN:
						if (parseInt(getNextToken()) != 10) throw new Error("Error reading MD5 file: Bad version");
						break;
					case COMMAND_TOKEN:
						ignoreLine();
						break;
					case NUM_JOINTS_TOKEN:
						num_joints = parseInt(getNextToken());
						break;
					case NUM_MESHES_TOKEN:
						num_meshes = parseInt(getNextToken());
						break;
					case JOINTS_TOKEN:
						parseJoints();
						break;
					case MESH_TOKEN:
						parseMesh();
						break;
				}
				if (eof) break;
			}
		}
		
		private function parseJoints():void {
			var ch:String;
			var i:int, j:int;
			var token:String = getNextToken();
			var joint0:Joint, joint1:Joint, joint2:Joint;
			var scale:Vector3D = new Vector3D(1, 1, 1);
			var jointParents:Vector.<int> = new Vector.<int>();
			skinInfo = new SkinInfo(null, new Vector.<Joint>());
			
			do {
				joint0 = new Joint();
				joint0.name = parseLiteralString();
				jointParents.push(parseInt(getNextToken()));
				joint0.offsetMatrix.recompose(Vector.<Vector3D>([parseVector3D(), parseQuaternion(), scale]), Orientation3D.QUATERNION);
				skinInfo.joints.push(joint0);
				if (!skinInfo.root) skinInfo.root = joint0;
				ch = getNextChar();
				if (ch == "/") {
					putBack();
					ch = getNextToken();
					if (ch == COMMENT_TOKEN) ignoreLine();
					ch = getNextChar();
				}
				if (ch != "}") putBack();
			} while (ch != "}");
			
			for (i = 0; i < num_joints; i++) {
				joint0 = skinInfo.joints[i];
				j = jointParents[i];
				if (j != -1) {
					joint1 = skinInfo.joints[j];
					if (joint1.firstChild) {
						joint2 = joint1.firstChild;
						while (joint2) {
							if (joint2.sibling) {
								joint2 = joint2.sibling;
							} else {
								joint2.sibling = joint0;
								break;
							}
						}
					} else {
						joint1.firstChild = joint0;
					}
				}
			}
		}
		
		private function parseMesh():void {
			var ch:String;
			var index:int;
			var num_verts:int;
			var num_tris:int;
			var num_weights:int;
			var rawUV:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			var rawVtWeight:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			var rawTriangle:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			var rawJointIndex:Vector.<int> = new Vector.<int>();
			var rawWeightBias:Vector.<Number> = new Vector.<Number>();
			var rawWeightPosition:Vector.<Vector3D> = new Vector.<Vector3D>();
			getNextToken();
			while (ch != "}") {
				ch = getNextToken();
				switch (ch) {
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case MESH_SHADER_TOKEN:
						ignoreLine();
						break;
					case MESH_NUM_VERTS_TOKEN:
						num_verts = parseInt(getNextToken());
						break;
					case MESH_NUM_TRIS_TOKEN:
						num_tris = parseInt(getNextToken());
						break;
					case MESH_NUM_WEIGHTS_TOKEN:
						num_weights = parseInt(getNextToken());
						break;
					case MESH_VERT_TOKEN:
						index = parseInt(getNextToken());
						getNextToken();
						rawUV[index] = Vector.<Number>([parseFloat(getNextToken()), parseFloat(getNextToken())]);
						getNextToken();
						rawVtWeight[index] = Vector.<int>([parseInt(getNextToken()), parseInt(getNextToken())]);
						break;
					case MESH_TRI_TOKEN:
						rawTriangle[parseInt(getNextToken())] = Vector.<int>([parseInt(getNextToken()), parseInt(getNextToken()), parseInt(getNextToken())]);
						break;
					case MESH_WEIGHT_TOKEN:
						index = parseInt(getNextToken());
						rawJointIndex[index] = parseInt(getNextToken());
						rawWeightBias[index] = parseFloat(getNextToken());
						rawWeightPosition[index] = parseVector3D();
						break;
				}
			}
			var weight:Number;
			var i:int, j:int, k:int, l:int;
			var vertex:Vertex;
			var position:Vector3D;
			var joint:Joint;
			var vertices:Vector.<Vertex> = new Vector.<Vertex>();
			var triangles:Vector.<Triangle> = new Vector.<Triangle>();
			for (i = 0; i < num_verts; i++) {
				vertex = vertices[i] = new Vertex(0, 0, 0, rawUV[i][0], rawUV[i][1]);
				vertex.weights = new Vector.<Number>();
				vertex.indices = new Vector.<uint>();
				j = rawVtWeight[i][0];
				k = rawVtWeight[i][1] - 1;
				while (k > -1) {
					l = rawJointIndex[j + k];
					vertex.indices.push(l);
					vertex.weights.push(rawWeightBias[j + k]);
					joint = skinInfo.joints[l];
					position = joint.offsetMatrix.transformVector(rawWeightPosition[j + k]);
					position.scaleBy(rawWeightBias[j + k]);
					vertex.x += position.x;
					vertex.y += position.y;
					vertex.z += position.z;
					k--;
				}
			}
			var triangle:Triangle;
			for (i = 0; i < num_tris; i++) {
				j = rawTriangle[i][0], k = rawTriangle[i][1], l = rawTriangle[i][2];
				triangles[i] = new Triangle(l, k, j, vertices[l].u, vertices[l].v, 
															vertices[k].u, vertices[k].v, 
															vertices[j].u, vertices[j].v);
			}
			skinInfo.vertices.push(vertices);
			skinInfo.triangles.push(triangles);
			Geometry.calculateNormal(vertices, triangles);
		}
		
		private function parseVector3D():Vector3D {
			var result:Vector3D = new Vector3D();
			getNextToken();
			result.x = parseFloat(getNextToken());
			result.y = parseFloat(getNextToken());
			result.z = parseFloat(getNextToken());
			getNextToken();
			return result;
		}
		
		private function parseQuaternion():Vector3D {
			var result:Vector3D = new Vector3D();
			getNextToken();
			result.x = parseFloat(getNextToken());
			result.y = parseFloat(getNextToken());
			result.z = parseFloat(getNextToken());
			var t:Number = 1 - result.x * result.x - result.y * result.y - result.z * result.z;
			result.w = t < 0 ? 0 : -Math.sqrt(t);
			getNextToken();
			return result;
		}
		
		private function putBack():void {
			parseIndex--;
			charLineIndex--;
			eof = parseIndex >= data.length;
		}
		
		private function getNextToken():String {
			var ch:String;
			var token:String = "";
			while (!eof) {
				ch = getNextChar();
				if (ch == " " || ch == "\r" || ch == "\n" || ch == "\t") {
					if (token != COMMENT_TOKEN) skipWhiteSpace();
					if (token != "") return token;
				}
				else token += ch;
				if (token == COMMENT_TOKEN) return token;
			}
			return token;
		}
		
		private function skipWhiteSpace():void {
			var ch:String;
			do {
				ch = getNextChar();
			} while (ch == "\n" || ch == " " || ch == "\r" || ch == "\t");
			putBack();
		}
		
		private function ignoreLine():void {
			var ch:String;
			while (!eof && ch != "\n") ch = getNextChar();
		}
		
		private function getNextChar():String {
			var ch:String = data.charAt(parseIndex++);
			if (ch == "\n") {
				++line;
				charLineIndex = 0;
			}
			else if (ch != "\r") ++charLineIndex;
			if (parseIndex >= data.length) eof = true;
			return ch;
		}
		
		private function parseLiteralString():String {
			skipWhiteSpace();
			var ch:String = getNextChar();
			var str:String = "";
			do {
				ch = getNextChar();
				if (ch != "\"") str += ch;
			} while (ch != "\"");
			return str;
		}
		
	}

}