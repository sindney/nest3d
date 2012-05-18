package nest.control.parsers 
{
	import flash.utils.ByteArray;
	
	import nest.object.data.*;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	
	/**
	 * OBJParser
	 */
	public class OBJParser {
		
		private var LINE_END:String = String.fromCharCode(10);
		private var SPACE:String = String.fromCharCode(32);
		private var BLANK:String = "";
		private var BLANK1:String = " ";
		private var SLASH:String = "/";
		private var VERTEX:String = "v";
		private var UV:String = "vt";
		private var INDEX:String = "f";
		
		private var _vertices:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		private var _indices:Vector.<uint>;
		
		private var _rawVertex:Vector.<Vertex>;
		private var _rawTriangle:Vector.<Triangle>;
		
		private var _faceIndex:int;
		private var _scale:Number;
		
		public function OBJParser() {
			
		}
		
		public function parse(model:ByteArray, scale:Number = 1):MeshData {
			_vertices = new Vector.<Number>();
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
				_rawVertex.push(new Vertex(_vertices[j], _vertices[j + 1], _vertices[j + 2], _uvs[k], 1 - _uvs[k + 1]));
			}
			_rawTriangle.push(new Triangle(_faceIndex, _faceIndex + 1, _faceIndex + 2));
			_faceIndex += 3;
		}
		
	}

}