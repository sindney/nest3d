package nest.control.parser 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.IKeyFrame;
	import nest.control.animation.VertexKeyFrame;
	import nest.object.Geometry;
	
	/**
	 * ParserMD2
	 * <p>Refer to Away3d.</p>
	 */
	public class ParserMD2 {
		
		private var vertexIndices:Vector.<uint>;
		private var uvIndices:Vector.<uint>;
		private var indices:Vector.<uint>;
		
		public var geom:Geometry;
		public var track:AnimationTrack;
		
		public function dispose():void {
			vertexIndices = null;
			uvIndices = null;
			indices = null;
			geom = null;
			track = null;
		}
		
		public function parse(model:ByteArray, normal:Boolean = false, tangent:Boolean = false):void {
			vertexIndices = new Vector.<uint>();
			uvIndices = new Vector.<uint>();
			indices = new Vector.<uint>();
			
			model.position = 0;
			model.endian = Endian.LITTLE_ENDIAN;
			
			if (model.readInt() != 844121161) throw new Error("Error reading MD2 file: Not a valid MD2 file");
			if (model.readInt() != 8) throw new Error("Error reading MD2 file: Bad version");
			
			var skin_width:int = model.readInt();
			var skin_height:int = model.readInt();
			var frame_size:int = model.readInt();
			var num_skins:int = model.readInt();
			var num_vertices:int = model.readInt();
			var num_uvs:int = model.readInt();
			var num_triangles:int = model.readInt();
			var num_glCommands:int = model.readInt();
			var num_frames:int = model.readInt();
			var offset_skins:int = model.readInt();
			var offset_uvs:int = model.readInt();
			var offset_triangles:int = model.readInt();
			var offset_frames:int = model.readInt();
			var offset_glCommands:int = model.readInt();
			var offset_end:int = model.readInt();
			
			model.position = offset_skins;
			var i:int, j:int, k:int;
			
			var uvs:Vector.<Number> = new Vector.<Number>(num_uvs * 2, true);
			model.position = offset_uvs;
			for (i = 0; i < num_uvs; i++) {
				uvs[i << 1] = model.readShort() / skin_width;
				uvs[(i << 1) + 1] = model.readShort() / skin_height;
			}
			
			var a:int, b:int, c:int, d:int, e:int, f:int;
			model.position = offset_triangles;
			for (i = 0; i < num_triangles; i++) {
				a = model.readUnsignedShort();
				b = model.readUnsignedShort();
				c = model.readUnsignedShort();
				d = model.readUnsignedShort();
				e = model.readUnsignedShort();
				f = model.readUnsignedShort();
				addIndex(a, d);
				addIndex(b, e);
				addIndex(c, f);
			}
			indices.fixed = true;
			
			j = uvIndices.length;
			var finalUVs:Vector.<Number> = new Vector.<Number>(j * 2, true);
			for (i = 0; i < j; i++) {
				a = i * 2;
				b = uvIndices[i] * 2;
				finalUVs[a] = uvs[b];
				finalUVs[a + 1] = uvs[b + 1];
			}
			
			var char:uint;
			var name:String;
			var flag:Boolean;
			var sx:Number, sy:Number, sz:Number, tx:Number, ty:Number, tz:Number;
			var frame:VertexKeyFrame;
			var vertices:Vector.<Number> = new Vector.<Number>();
			track = new AnimationTrack(new Vector.<IKeyFrame>());
			for (i = 0; i < num_frames; i++ ) {
				sx = model.readFloat();
				sy = model.readFloat();
				sz = model.readFloat();
				tx = model.readFloat();
				ty = model.readFloat();
				tz = model.readFloat();
				
				name = "";
				flag = true;
				for (j = 0; j < 16; j++) {
					char = model.readUnsignedByte();
					flag &&= (char != 0);
					if (flag) name += String.fromCharCode(char);
				}
				
				for (j = 0; j < num_vertices; j++) {
					k = j * 3;
					vertices[k] = (sx * model.readUnsignedByte() + tx);
					vertices[k + 1] = (sy * model.readUnsignedByte() + ty);
					vertices[k + 2] = (sz * model.readUnsignedByte() + tz);
					model.readUnsignedByte();
				}
				
				frame = new VertexKeyFrame();
				frame.vertices = new Vector.<Number>();
				frame.name = name;
				frame.time = i;
				k = vertexIndices.length;
				for (j = 0; j < k; j++) {
					a = j * 3;
					b = vertexIndices[j] * 3;
					frame.vertices[a] = vertices[b];
					frame.vertices[a + 1] = vertices[b + 2];
					frame.vertices[a + 2] = vertices[b + 1];
				}
				frame.vertices.fixed = true;
				track.frames.push(frame);
			}
			
			geom = new Geometry();
			geom.numVertices = (track.frames[0] as VertexKeyFrame).vertices.length / 3;
			geom.numTriangles = indices.length / 3;
			geom.indices = indices;
			geom.uvs = finalUVs;
			
			var max:Vector3D = new Vector3D();
			var min:Vector3D = new Vector3D();
			
			for each(frame in track.frames) {
				if (normal) {
					geom.vertices = frame.vertices;
					Geometry.calculateNormal(geom);
					frame.normals = geom.normals;
				}
				if (tangent) {
					geom.vertices = frame.vertices;
					Geometry.calculateTangent(geom);
					frame.tangents = geom.tangents;
				}
				max.setTo(0, 0, 0);
				min.setTo(0, 0, 0);
				j = frame.vertices.length / 3;
				for (i = 0; i < j; i++) {
					k = i * 3;
					sx = frame.vertices[k];
					if (sx > max.x) max.x = sx;
					else if (sx < min.x) min.x = sx;
					sx = frame.vertices[k + 1];
					if (sx > max.y) max.y = sx;
					else if (sx < min.y) min.y = sx;
					sx = frame.vertices[k + 2];
					if (sx > max.z) max.z = sx;
					else if (sx < min.z) min.z = sx;
				}
				frame.bounds[0] = min.x; frame.bounds[1] = min.y; frame.bounds[2] = min.z;
				frame.bounds[3] = max.x; frame.bounds[4] = max.y; frame.bounds[5] = max.z;
			}
			
			frame = track.frames[0] as VertexKeyFrame;
			
			geom.vertices = frame.vertices.concat();
			geom.vertices.fixed = true;
			if (normal) {
				geom.normals = frame.normals.concat();
				geom.normals.fixed = true;
			}
			if (tangent) {
				geom.tangents = frame.tangents.concat();
				geom.tangents.fixed = true;
			}
			
			vertexIndices = null;
			uvIndices = null;
			indices = null;
		}
		
		private function addIndex(vertexIndex:uint, uvIndex:uint):void {
			var index:int = findIndex(vertexIndex, uvIndex);
			if (index == -1) {
				indices.push(vertexIndices.length);
				vertexIndices.push(vertexIndex);
				uvIndices.push(uvIndex);
			} else {
				indices.push(index);
			}
		}
		
		private function findIndex(vertexIndex:uint, uvIndex:uint):int {
			var i:int, l:int = vertexIndices.length;
			for (i = 0; i < l; ++i)
				if (vertexIndices[i] == vertexIndex && uvIndices[i] == uvIndex) return i;
			return -1;
		}
		
	}

}