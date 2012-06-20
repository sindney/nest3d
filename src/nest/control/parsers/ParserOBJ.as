package nest.control.parsers 
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import nest.object.data.*;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	
	/**
	 * ParserOBJ
	 */
	public class ParserOBJ {
		
		private var LINE_END:String = String.fromCharCode(10);
		private var SPACE:String = String.fromCharCode(32);
		private var BLANK:String = "";
		private var BLANK1:String = " ";
		private var SLASH:String = "/";
		private var VERTEX:String = "v";
		private var NORMAL:String = "vn";
		private var UV:String = "vt";
		private var INDEX:String = "f";
		
		private var _vertices:Vector.<Number>;
		private var _normals:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		private var _indices:Vector.<uint>;
		
		private var _rawVertex:Vector.<Vertex>;
		private var _rawTriangle:Vector.<Triangle>;
		
		private var _faceIndex:int;
		private var _scale:Number;
		
		public function ParserOBJ() {
			
		}
		
		public function parse(model:ByteArray, scale:Number = 1):MeshData {
			_vertices = new Vector.<Number>();
			_normals = new Vector.<Number>();
			_uvs = new Vector.<Number>();
			_indices = new Vector.<uint>();
			
			_rawVertex = new Vector.<Vertex>();
			_rawTriangle = new Vector.<Triangle>();
			
			_faceIndex = 0;
			_scale = scale;
			
			var source:String = model.readUTFBytes(model.bytesAvailable);
			var lines:Array = source.split(LINE_END);
			var i:int = 0, j:int = lines.length;
			for (i == 0; i < j; i++)
				parseLine(lines[i]);
			
			_vertices = null;
			_normals = null;
			_uvs = null;
			_indices = null;
			
			return new MeshData(_rawVertex, _rawTriangle);
		}
		
		private function parseLine(line:String):void {
			var words:Array = line.split(SPACE);
			if (words.length > 0) {
				var data:Array = words.slice(1);
			} else {
				return;
			}
			
			switch(words[0]) {
				case VERTEX:
					parseVertex(data);
					break;
				case NORMAL:
					parseNormal(data);
					break;
				case UV:
					parseUV(data);
					break;
				case INDEX:
					parseIndex(data);
					break;
			}
		}
		
		private function parseVertex(data:Array):void {
			if (data[0] == BLANK || data[0] == BLANK1)
				data = data.slice(1);
			_vertices.push(Number(data[0]) * _scale);
			_vertices.push(Number(data[1]) * _scale);
			_vertices.push(Number(data[2]) * _scale);
		}
		
		private function parseNormal(data:Array):void {
			if (data[0] == BLANK || data[0] == BLANK1)
				data = data.slice(1);
			_normals.push(Number(data[0]));
			_normals.push(Number(data[1]));
			_normals.push(Number(data[2]));
		}
		
		private function parseUV(data:Array):void {
			if (data[0] == BLANK || data[0] == BLANK1)
				data = data.slice(1);
			_uvs.push(Number(data[0]));
			_uvs.push(Number(data[1]));
		}
		
		private function parseIndex(data:Array):void {
			var triplet:String;
			var subdata:Array;
			var vertexIndex:int;
			var uvIndex:int;
			
			var v0:Vertex, v1:Vertex, v2:Vertex;
			var i:int, j:int, k:int, l:int = data.length;
			var start:int = 0;
			while (data[start] == BLANK || data[start] == BLANK1)
				start++;
			l = start + 3;
			for (i = start; i < l; ++i) {
				triplet = data[i];
				subdata = triplet.split(SLASH);
				vertexIndex = int(subdata[0]) - 1;
				uvIndex = int(subdata[1]) - 1;
				
				if (vertexIndex < 0) vertexIndex = 0;
				if (uvIndex < 0) uvIndex = 0;
				
				j = vertexIndex * 3;
				k = uvIndex * 2;
				v0 = new Vertex(_vertices[j], _vertices[j + 1], _vertices[j + 2], _uvs[k], 1 - _uvs[k + 1]);
				v0.normal.setTo(_normals[j], _normals[j + 1], _normals[j + 2]);
				_rawVertex.push(v0);
			}
			
			var t:Triangle = new Triangle(_faceIndex, _faceIndex + 1, _faceIndex + 2);
			
			v0 = _rawVertex[_faceIndex];
			v1 = _rawVertex[_faceIndex + 1];
			v2 = _rawVertex[_faceIndex + 2];
			
			var vt:Vector3D = new Vector3D(v1.x - v0.x, v1.y - v0.y, v1.z - v0.z);
			t.normal.setTo(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
			t.normal.copyFrom(vt.crossProduct(t.normal));
			
			_rawTriangle.push(t);
			_faceIndex += 3;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.control.parsers.ParserOBJ]";
		}
		
	}

}