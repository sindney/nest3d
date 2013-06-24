package nest.control.parser 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import nest.object.Geometry;
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
		
		private var mesh:Mesh;
		
		private var vertices:Vector.<Number>;
		private var uvs:Vector.<Number>;
		private var indices:Vector.<uint>;
		
		public function dispose():void {
			_objects = null;
			mesh = null;
			vertices = null;
			uvs = null;
			indices = null;
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
			
			model.position = 6;
			readChunk(model, model.length);
		}
		
		private function readChunk(data:ByteArray, size:uint):void {
			var init:uint = data.position;
			var id:uint = data.readUnsignedShort();
			var length:uint = data.readUnsignedInt();
			
			var i:int, j:int, k:int;
			
			switch(id) {
				case VERSION:
					if (data.readInt() < 3) throw new Error("Error reading 3DS file: Not a valid 3DS file version");
					break;
				case EDITOR:
					readChunk(data, init + length);
					break;
				case OBJECTS:
					mesh = new Mesh();
					mesh.name = readName(data);
					_objects.push(mesh);
					readChunk(data, init + length);
					return;
				case MESH:
					readChunk(data, init + length);
					return;
				case VERTICES:
					vertices = new Vector.<Number>();
					j = data.readUnsignedShort();
					for (i = 0; i < j; i++) {
						vertices.push(data.readFloat(), data.readFloat(), data.readFloat());
					}
					break;
				case UVS:
					uvs = new Vector.<Number>();
					j = data.readUnsignedShort();
					for (i = 0; i < j; i++) {
						uvs.push(data.readFloat(), 1 - data.readFloat());
					}
					break;
				case INDICES:
					indices = new Vector.<uint>();
					j = data.readUnsignedShort();
					for (i = 0; i < j; i++) {
						indices.push(data.readUnsignedShort(), data.readUnsignedShort(), data.readUnsignedShort());
						data.position += 2;
					}
					vertices.fixed = uvs.fixed = indices.fixed = true;
					var geom:Geometry = new Geometry();
					geom.vertices = vertices;
					geom.uvs = uvs;
					geom.indices = indices;
					mesh.geometry = geom;
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