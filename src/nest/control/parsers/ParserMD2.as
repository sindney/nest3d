package nest.control.parsers 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.control.animation.AnimationClip;
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.VertexKeyFrame;
	import nest.object.AnimatedMesh;
	import nest.object.data.MeshData;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.view.lights.AmbientLight;
	import nest.view.lights.DirectionalLight;
	import nest.view.lights.ILight;
	import nest.view.materials.ColorMaterial;
	/**
	 * ParserMD2
	 */
	public class ParserMD2 
	{
		
		public function ParserMD2() 
		{
			
		}
		
		private var skin_width:int;
		private var skin_height:int;
		private var frame_size:int;
		private var num_skins:int;
		private var num_vertices:int;
		private var num_uvs:int;
		private var num_triangles:int;
		private var num_glCommands:int;
		private var num_frames:int;
		private var offset_skins:int;
		private var offset_uvs:int;
		private var offset_triangles:int;
		private var offset_frames:int;
		private var offset_glCommands:int;
		private var offset_end:int;
		
		public function parse(model:ByteArray,scale:Number=1):AnimatedMesh {
			
			model.position = 0;
			model.endian = Endian.LITTLE_ENDIAN;
			
			//header
			if (model.readInt() != 844121161) throw new Error("Error reading MD2 file: Not a valid MD2 file");
			if (model.readInt() != 8) throw new Error("Error reading MD2 file: Bad version");
			
			//skin size
			skin_width = model.readInt();
			skin_height = model.readInt();
			
			//frame size
			frame_size = model.readInt();
			
			//num skins
			num_skins = model.readInt();
			
			//num vertices
			num_vertices = model.readInt();
			
			//num uvs
			num_uvs = model.readInt();
			
			//num triangles
			num_triangles = model.readInt();
			
			//num OpenGL commands
			num_glCommands = model.readInt();
			
			//num frames
			num_frames = model.readInt();
			
			//offset skins
			offset_skins = model.readInt();
			
			//offset uvs
			offset_uvs = model.readInt();
			
			//offset triangles
			offset_triangles = model.readInt();
			
			//offset frames
			offset_frames = model.readInt();
			
			//offset OpenGL commands
			offset_glCommands = model.readInt();
			
			//offset end of the file
			offset_end = model.readInt();
			
			//head file end
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(num_vertices, true);
			var uvs:Vector.<Number> = new Vector.<Number>(num_uvs * 2, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(num_triangles, true);
			var vertexTrack:AnimationTrack = new AnimationTrack();
			
			//get texture name
			model.position = offset_skins;
			var texture_name:String = "";
			var i:int, j:int,k:uint, char:uint;
			var u:Number, v:Number;
			var tri:Triangle;
			var frame:VertexKeyFrame;
			if (num_skins>0) {
				for (i = 0; i < 64;i++ ) {
					char = model.readUnsignedByte();
					if (char==0) {
						break;
					}else {
						texture_name += String.fromCharCode(char);
					}
				}
			}
			
			//get uvs
			model.position = offset_uvs;
			for (i = 0; i < num_uvs; i++) {
				uvs[i << 1] = model.readShort() / skin_width;
				uvs[(i << 1) + 1] = model.readShort() / skin_height;
			}
			//get triangles
			model.position = offset_triangles;
			for (i = 0; i < num_triangles;i++ ) {
				var index0:uint = model.readUnsignedShort();
				var index1:uint = model.readUnsignedShort();
				var index2:uint = model.readUnsignedShort();
				
				var uv0:uint = model.readUnsignedShort();
				var uv1:uint = model.readUnsignedShort();
				var uv2:uint = model.readUnsignedShort();
				
				tri = new Triangle(index2, index1, index0);
				
				u = uvs[uv0 << 1];
				v = uvs[(uv0 << 1) + 1];
				vertices[index0] = new Vertex(0, 0, 0, u, v);
				tri.u2 = u;
				tri.v2 = v;
				
				u = uvs[uv1 << 1];
				v = uvs[(uv1 << 1) + 1];
				vertices[index1] = new Vertex(0, 0, 0, u, v);
				tri.u1 = u;
				tri.v1 = v;
				
				u = uvs[uv2 << 1];
				v = uvs[(uv2 << 1) + 1];
				vertices[index2] = new Vertex(0, 0, 0, u, v);
				tri.u0 = u;
				tri.v0 = v;
				
				triangles[i] = tri;
			}
			
			//get animation frames
			for (i = 0; i < num_frames; i++ ) {
				//frame scale and translate
				var sx:Number = model.readFloat();
				var sy:Number = model.readFloat();
				var sz:Number = model.readFloat();
				
				var tx:Number = model.readFloat();
				var ty:Number = model.readFloat();
				var tz:Number = model.readFloat();
				
				//frame name
				var name:String = ""; var notEnd:Boolean = true;
				for (j = 0; j < 16;j++ ) {
					char = model.readUnsignedByte();
					notEnd &&= (char != 0);
					if (notEnd) name += String.fromCharCode(char);
				}
				
				//frame vertices
				frame = new VertexKeyFrame();
				frame.name = name;
				frame.time = i;
				frame.vertices = new Vector.<Number>(num_vertices * 3, true);
				for (j = 0, k = 0; j < num_vertices; j++, k += 3 ) {
					frame.vertices[k] = (sx * model.readUnsignedByte() + tx) * scale;
					frame.vertices[k + 1] = (sy * model.readUnsignedByte() + ty) * scale;
					frame.vertices[k + 2] = (sz * model.readUnsignedByte() + tz) * scale;
					
					//index of normal
					model.readUnsignedByte();
				}
				vertexTrack.addFrame(frame);
			}
			
			//reset vertex data to frame0
			var vs0:Vector.<Number> = (vertexTrack.frameList as VertexKeyFrame).vertices;
			for (i = 0,j=0; i < num_vertices;i++,j+=3 ) {
				if (vertices[i]) {
					vertices[i].x = vs0[j];
					vertices[i].y = vs0[j+1];
					vertices[i].z = vs0[j+2];
				}else {
					//trace("no vertices!!");
					vertices[i] = new Vertex(vs0[j], vs0[j + 1], vs0[j + 2]);
				}
			}
			
			MeshData.calculateNormal(vertices, triangles);
			var data:MeshData = new MeshData(vertices, triangles);
			var clips:Vector.<AnimationClip> = new Vector.<AnimationClip>(1, true);
			clips[0] = new AnimationClip();
			clips[0].addTrack(vertexTrack);
			
			var testMat:ColorMaterial = new ColorMaterial();
			var ambLight:AmbientLight = new AmbientLight();
			ambLight.next = new DirectionalLight(0xffffff, 1, 1, 1);
			testMat.light = ambLight;
			testMat.update();
			var aniMesh:AnimatedMesh = new AnimatedMesh(data, testMat);
			aniMesh.clips = clips;
			return aniMesh;
		}
		
	}

}