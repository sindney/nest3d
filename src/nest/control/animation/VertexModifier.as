package nest.control.animation 
{
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	
	/**
	 * VertexModifier
	 */
	public class VertexModifier implements IAnimationModifier {
		
		public function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var tk1:VertexKeyFrame = k1 as VertexKeyFrame;
			var tk2:VertexKeyFrame = k2 as VertexKeyFrame;
			var result:VertexKeyFrame = new VertexKeyFrame();
			result.time = tk1.time * w1 + w2 * tk2.time;
			if (tk1.vertices && tk2.vertices) {
				var i:int;
				var l:int = tk1.vertices.length;
				var copy:Vector.<Number> = new Vector.<Number>(l, true);
				for (i = 0; i < l; i++) {
					copy[i] = tk1.vertices[i] * w1 + tk2.vertices[i] * w2;
				}
				result.vertices = copy;
				l = tk1.normals.length;
				copy = new Vector.<Number>(l, true);
				for (i = 0; i < l; i++) {
					copy[i] = tk1.normals[i] * w1 + tk2.normals[i] * w2;
				}
				result.normals = copy;
			}
			return result;
		}
		
		public function calculate(target:IAnimatable, root:IKeyFrame, time:Number):void {
			var frame:IKeyFrame = root;
			var offset:Number = root.next.time;
			
			while (time >= frame.next.time) {
				frame = frame.next;
				offset = frame.next.time;
			}
			
			var w1:Number = (offset - time) / (offset - frame.time);
			var w2:Number = 1 - w1;
			
			var mesh:IMesh = target as IMesh;
			var curVertices:Vector.<Number> = (frame as VertexKeyFrame).vertices;
			var nextVertices:Vector.<Number> = (frame.next as VertexKeyFrame).vertices;
			var curNormals:Vector.<Number> = (frame as VertexKeyFrame).normals;
			var nextNormals:Vector.<Number> = (frame.next as VertexKeyFrame).normals;
			var i:int, j:int;
			var l:int = curVertices.length / 3;
			for (i = 0, j = 0; i < l; i++, j += 3) {
				var vertex:Vertex = mesh.geom.vertices[i];
				vertex.x = curVertices[j] * w1 + nextVertices[j] * w2;
				vertex.y = curVertices[j + 1] * w1 + nextVertices[j + 1] * w2;
				vertex.z = curVertices[j + 2] * w1 + nextVertices[j + 2] * w2;
				vertex.normal.x = curNormals[j] * w1 + nextNormals[j] * w2;
				vertex.normal.y = curNormals[j + 1] * w1 + nextNormals[j + 1] * w2;
				vertex.normal.z = curNormals[j + 2] * w1 + nextNormals[j + 2] * w2;
			}
			mesh.geom.update(false);
		}
		
	}

}