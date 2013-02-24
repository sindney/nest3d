package nest.control.animation 
{
	import nest.object.geom.Geometry;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	
	/**
	 * VertexModifier
	 */
	public class VertexModifier implements IAnimationModifier {
		
		public function calculate(target:IMesh, k1:IKeyFrame, k2:IKeyFrame, time:Number, weight:Number):void {
			var w1:Number = weight * (k2.time - time) / (k2.time - k1.time);
			var w2:Number = weight - w1;
			
			var vt0:Vector.<Number> = (k1 as VertexKeyFrame).vertices;
			var vt1:Vector.<Number> = (k2 as VertexKeyFrame).vertices;
			var nm0:Vector.<Number> = (k1 as VertexKeyFrame).normals;
			var nm1:Vector.<Number> = (k2 as VertexKeyFrame).normals;
			var i:int, j:int;
			var l:int = vt0.length / 3;
			for (i = 0, j = 0; i < l; i++, j += 3) {
				var vertex:Vertex = target.geom.vertices[i];
				vertex.x = vt0[j] * w1 + vt1[j] * w2;
				vertex.y = vt0[j + 1] * w1 + vt1[j + 1] * w2;
				vertex.z = vt0[j + 2] * w1 + vt1[j + 2] * w2;
				vertex.nx = nm0[j] * w1 + nm1[j] * w2;
				vertex.ny = nm0[j + 1] * w1 + nm1[j + 1] * w2;
				vertex.nz = nm0[j + 2] * w1 + nm1[j + 2] * w2;
			}
			
			Geometry.uploadGeometry(target.geom, true, target.geom.normalBuffer != null, target.geom.uvBuffer != null, false);
		}
		
	}

}