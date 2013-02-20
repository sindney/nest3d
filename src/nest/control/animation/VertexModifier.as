package nest.control.animation 
{
	import nest.control.util.GeometryUtil;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	
	/**
	 * VertexModifier
	 */
	public class VertexModifier implements IAnimationModifier {
		
		public function calculate(target:IMesh, root:IKeyFrame, time:Number):void {
			var frame:IKeyFrame = root;
			var offset:Number = root.next.time;
			
			while (time >= frame.next.time) {
				frame = frame.next;
				offset = frame.next.time;
			}
			
			var w1:Number = (offset - time) / (offset - frame.time);
			var w2:Number = 1 - w1;
			
			var curVertices:Vector.<Number> = (frame as VertexKeyFrame).vertices;
			var nextVertices:Vector.<Number> = (frame.next as VertexKeyFrame).vertices;
			var curNormals:Vector.<Number> = (frame as VertexKeyFrame).normals;
			var nextNormals:Vector.<Number> = (frame.next as VertexKeyFrame).normals;
			var i:int, j:int;
			var l:int = curVertices.length / 3;
			for (i = 0, j = 0; i < l; i++, j += 3) {
				var vertex:Vertex = target.geom.vertices[i];
				vertex.x = curVertices[j] * w1 + nextVertices[j] * w2;
				vertex.y = curVertices[j + 1] * w1 + nextVertices[j + 1] * w2;
				vertex.z = curVertices[j + 2] * w1 + nextVertices[j + 2] * w2;
				vertex.normal.x = curNormals[j] * w1 + nextNormals[j] * w2;
				vertex.normal.y = curNormals[j + 1] * w1 + nextNormals[j + 1] * w2;
				vertex.normal.z = curNormals[j + 2] * w1 + nextNormals[j + 2] * w2;
			}
			
			GeometryUtil.uploadGeometry(target.geom, i, j, -1, 0);
		}
		
	}

}