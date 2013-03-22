package nest.control.animation 
{
	import flash.geom.Vector3D;
	
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	
	/**
	 * VertexModifier
	 */
	public class VertexModifier implements IAnimationModifier {
		
		public static const GEOM_INDEX:String = "geom_index";
		public static const VERTEX_NORMAL:String = "vertex_normal";
		public static const VERTEX_TANGENT:String = "vertex_tangent";
		
		public function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void {
			var w1:Number = track.weight * (k2.time - time) / (k2.time - k1.time);
			var w2:Number = track.weight - w1;
			var geom:Geometry = track.target.geometries[track.parameters[GEOM_INDEX]];
			var vt0:Vector.<Number> = (k1 as VertexKeyFrame).vertices;
			var vt1:Vector.<Number> = (k2 as VertexKeyFrame).vertices;
			var nm0:Vector.<Number> = (k1 as VertexKeyFrame).normals;
			var nm1:Vector.<Number> = (k2 as VertexKeyFrame).normals;
			var tg0:Vector.<Number> = (k1 as VertexKeyFrame).tangents;
			var tg1:Vector.<Number> = (k2 as VertexKeyFrame).tangents;
			var bd0:Vector.<Number> = (k1 as VertexKeyFrame).bounds;
			var bd1:Vector.<Number> = (k2 as VertexKeyFrame).bounds;
			var normal:Boolean = track.parameters[VERTEX_NORMAL];
			var tangent:Boolean = track.parameters[VERTEX_TANGENT];
			var i:int, j:int;
			for (i = 0; i < geom.numVertices; i++) {
				j = i * 3;
				geom.vertices[j] = vt0[j] * w1 + vt1[j] * w2;
				geom.vertices[j + 1] = vt0[j + 1] * w1 + vt1[j + 1] * w2;
				geom.vertices[j + 2] = vt0[j + 2] * w1 + vt1[j + 2] * w2;
				if (normal) {
					geom.normals[j] = nm0[j] * w1 + nm1[j] * w2;
					geom.normals[j + 1] = nm0[j + 1] * w1 + nm1[j + 1] * w2;
					geom.normals[j + 2] = nm0[j + 2] * w1 + nm1[j + 2] * w2;
				}
				if (tangent) {
					geom.tangents[j] = tg0[j] * w1 + tg1[j] * w2;
					geom.tangents[j + 1] = tg0[j + 1] * w1 + tg1[j + 1] * w2;
					geom.tangents[j + 2] = tg0[j + 2] * w1 + tg1[j + 2] * w2;
				}
			}
			var bound:Bound = track.target.bound;
			var min:Vector3D = bound.vertices[0], max:Vector3D = bound.vertices[7];
			min.setTo(bd0[0] * w1 + bd1[0] * w2, bd0[1] * w1 + bd1[1] * w2, bd0[2] * w1 + bd1[2] * w2);
			max.setTo(bd0[3] * w1 + bd1[3] * w2, bd0[4] * w1 + bd1[4] * w2, bd0[5] * w1 + bd1[5] * w2);
			bound.vertices[1].setTo(max.x, min.y, min.z);
			bound.vertices[2].setTo(min.x, max.y, min.z);
			bound.vertices[3].setTo(max.x, max.y, min.z);
			bound.vertices[4].setTo(min.x, min.y, max.z);
			bound.vertices[5].setTo(max.x, min.y, max.z);
			bound.vertices[6].setTo(min.x, max.y, max.z);
			Geometry.uploadGeometry(geom, true, normal, tangent, false, false);
		}
		
	}

}