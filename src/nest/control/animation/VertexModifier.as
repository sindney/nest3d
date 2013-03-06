package nest.control.animation 
{
	import flash.geom.Vector3D;
	import nest.object.geom.Bound;
	
	import nest.object.geom.Geometry;
	import nest.object.geom.Vertex;
	
	/**
	 * VertexModifier
	 */
	public class VertexModifier implements IAnimationModifier {
		
		public static const GEOM_INDEX:String = "geom_index";
		
		public function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void {
			var w1:Number = track.weight * (k2.time - time) / (k2.time - k1.time);
			var w2:Number = track.weight - w1;
			
			var geom:Geometry = track.target.geometries[track.parameters[GEOM_INDEX]];
			var vt0:Vector.<Number> = (k1 as VertexKeyFrame).vertices;
			var vt1:Vector.<Number> = (k2 as VertexKeyFrame).vertices;
			var nm0:Vector.<Number> = (k1 as VertexKeyFrame).normals;
			var nm1:Vector.<Number> = (k2 as VertexKeyFrame).normals;
			var bd0:Vector.<Number> = (k1 as VertexKeyFrame).bounds;
			var bd1:Vector.<Number> = (k2 as VertexKeyFrame).bounds;
			var i:int, j:int;
			var l:int = vt0.length / 3;
			for (i = 0, j = 0; i < l; i++, j += 3) {
				var vertex:Vertex = geom.vertices[i];
				vertex.x = vt0[j] * w1 + vt1[j] * w2;
				vertex.y = vt0[j + 1] * w1 + vt1[j + 1] * w2;
				vertex.z = vt0[j + 2] * w1 + vt1[j + 2] * w2;
				vertex.nx = nm0[j] * w1 + nm1[j] * w2;
				vertex.ny = nm0[j + 1] * w1 + nm1[j + 1] * w2;
				vertex.nz = nm0[j + 2] * w1 + nm1[j + 2] * w2;
			}
			var min:Vector3D, max:Vector3D;
			var bound:Bound = track.target.bound;
			min.setTo(bd0[0] * w1 + bd1[0] * w2, bd0[1] * w1 + bd1[1] * w2, bd0[2] * w1 + bd1[2] * w2);
			max.setTo(bd0[3] * w1 + bd1[3] * w2, bd0[4] * w1 + bd1[4] * w2, bd0[5] * w1 + bd1[5] * w2);
			bound.vertices[1].setTo(max.x, min.y, min.z);
			bound.vertices[2].setTo(min.x, max.y, min.z);
			bound.vertices[3].setTo(max.x, max.y, min.z);
			bound.vertices[4].setTo(min.x, min.y, max.z);
			bound.vertices[5].setTo(max.x, min.y, max.z);
			bound.vertices[6].setTo(min.x, max.y, max.z);
			bound.center.setTo((max.x + min.x) * 0.5, (max.y + min.y) * 0.5, (max.z + min.z) * 0.5);
			
			Geometry.uploadGeometry(geom, true, geom.normalBuffer != null, geom.uvBuffer != null, false);
		}
		
	}

}