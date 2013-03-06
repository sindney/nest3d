package nest.control.parser 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.object.geom.Geometry;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.Mesh;
	
	/**
	 * Parser3DS
	 */
	public class Parser3DS {
		
		private const HEADER:uint = 0x4d4d;
		private const VERSION:uint = 0x0002;
		private const EDITOR:uint = 0x3d3d;
		private const OBJECTS:uint = 0x4000;
		private const MESH:uint = 0x4100;
		private const VERTICES:uint = 0x4110;
		private const INDICES:uint = 0x4120;
		private const UVS:uint = 0x4140;
		
		private var _objects:Vector.<Mesh>;
		
		private var last:Mesh;
		private var name:String;
		
		private var rawVertices:Vector.<Vertex>;
		private var rawTriangles:Vector.<Triangle>;
		
		public function Parser3DS() {
			
		}
		
		public function dispose():void {
			_objects = null;
			last = null;
			name = null;
			rawVertices = null;
			rawTriangles = null;
		}
		
		public function getObjectByName(name:String):Mesh {
			var object:Mesh;
			for each(object in _objects) {
				if (object.name == name) return object;
			}
			return null;
		}
		
		public function parse(model:ByteArray):void {
			_objects = new Vector.<Mesh>();
			
			model.endian = Endian.LITTLE_ENDIAN;
			model.position = 0;
			
			if (model.readUnsignedShort() != HEADER) throw new Error("Error reading 3DS file: Not a valid 3DS file");
			
			rawVertices = new Vector.<Vertex>();
			rawTriangles = new Vector.<Triangle>();
			
			model.position = 6;
			readChunk(model, model.length);
			
			rawVertices = null;
			rawTriangles = null;
		}
		
		private function readChunk(data:ByteArray, size:uint):void {
			var init:uint = data.position;
			var id:uint = data.readUnsignedShort();
			var length:uint = data.readUnsignedInt();
			
			var i:int, j:int, k:int;
			var vertex:Vertex;
			var triangle:Triangle;
			
			switch(id) {
				case VERSION:
					if (data.readInt() < 3) throw new Error("Error reading 3DS file: Not a valid 3DS file version");
					break;
				case EDITOR:
					readChunk(data, init + length);
					break;
				case OBJECTS:
					name = readName(data);
					readChunk(data, init + length);
					return;
				case MESH:
					last = new Mesh();
					last.name = name;
					readChunk(data, init + length);
					return;
				case VERTICES:
					j = data.readUnsignedShort();
					for (i = 0; i < j; i++) {
						rawVertices.push(new Vertex(data.readFloat(), data.readFloat(), data.readFloat()));
					}
					break;
				case UVS:
					i = 0;
					j = rawVertices.length;
					data.position += 2;
					for (i = 0; i < j; i++) {
						vertex = rawVertices[i];
						vertex.u = data.readFloat();
						vertex.v = 1 - data.readFloat();
					}
					break;
				case INDICES:
					j = data.readUnsignedShort();
					for (i = 0; i < j; i++) {
						triangle = new Triangle(data.readUnsignedShort(), data.readUnsignedShort(), data.readUnsignedShort());
						rawTriangles.push(triangle);
						for (k = 0; k < 3; k++) {
							vertex = rawVertices[triangle.indices[k]];
							triangle.uvs[k * 2] = vertex.u;
							triangle.uvs[k * 2 + 1] = vertex.v;
						}
						data.position += 2;
					}
					Geometry.calculateNormal(rawVertices, rawTriangles);
					last.geometries.push(new Geometry(rawVertices, rawTriangles));
					_objects.push(last);
					last = null;
					break;
			}
			
			data.position = init + length;
			if (data.position < data.length) readChunk(data, size);
		}
		
		private function readName(data:ByteArray):String {
			var byte:uint = data.readUnsignedByte();
			var char:String = String.fromCharCode(byte);
			var result:String = "";
			while (byte != 0) {
				result += char;
				byte = data.readUnsignedByte();
				char = String.fromCharCode(byte);
			}
			return result;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get objects():Vector.<Mesh> {
			return _objects;
		}
		
	}

}