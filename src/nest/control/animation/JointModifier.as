package nest.control.animation 
{
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	import nest.control.util.Quaternion;
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.object.geom.SkinInfo;
	import nest.object.geom.Joint;
	import nest.object.geom.Vertex;
	
	/**
	 * JointModifier
	 */
	public class JointModifier implements IAnimationModifier {
		
		public static const JOINT_POSITION:String = "joint_position";
		public static const JOINT_ROTATION:String = "joint_rotation";
		public static const JOINT_SCALE:String = "joint_scale";
		
		public function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void {
			var w1:Number = track.weight * (k2.time - time) / (k2.time - k1.time);
			var w2:Number = track.weight - w1;
			var key1:JointKeyFrame = k1 as JointKeyFrame;
			var key2:JointKeyFrame = k2 as JointKeyFrame;
			var comp0:Vector3D = new Vector3D(), comp1:Vector3D = new Vector3D();
			var comp2:Vector3D = new Vector3D(), comp3:Vector3D = new Vector3D();
			var comp4:Vector3D = new Vector3D(1, 1, 1);
			var components:Vector.<Vector3D> = Vector.<Vector3D>([comp0, comp1, comp4]);
			var skin:SkinInfo = track.target.skinInfo;
			var i:int, j:int, k:int, l:int = skin.joints.length;
			var b0:Boolean = track.parameters[JointModifier.JOINT_POSITION];
			var b1:Boolean = track.parameters[JointModifier.JOINT_ROTATION];
			var b2:Boolean = track.parameters[JointModifier.JOINT_SCALE];
			if (b0) {
				if (b1) {
					k = b2 ? 10 : 7;
				} else {
					k = b2 ? 6 : 3;
				}
			} else {
				if (b1) {
					k = b2 ? 7 : 4;
				} else {
					k = b2 ? 3 : 0;
				}
			}
			var joint:Joint;
			for (i = 0; i < l; i++) {
				joint = skin.joints[i];
				j = i * k;
				if (b0) {
					comp0.x = key1.transforms[j] * w1 + key2.transforms[j++] * w2;
					comp0.y = key1.transforms[j] * w1 + key2.transforms[j++] * w2;
					comp0.z = key1.transforms[j] * w1 + key2.transforms[j++] * w2;
				} else {
					comp0.x = comp0.y = comp0.z = 0;
				}
				if (b1) {
					comp2.x = key1.transforms[j], comp3.x = key2.transforms[j++];
					comp2.y = key1.transforms[j], comp3.y = key2.transforms[j++];
					comp2.z = key1.transforms[j], comp3.z = key2.transforms[j++];
					comp2.w = key1.transforms[j], comp3.w = key2.transforms[j++];
					Quaternion.slerp(comp2, comp3, w2, comp1);
				} else {
					comp1.x = comp1.y = comp1.z = 0;
					comp1.w = 1;
				}
				if (b2) {
					comp4.x = key1.transforms[j] * w1 + key2.transforms[j++] * w2;
					comp4.y = key1.transforms[j] * w1 + key2.transforms[j++] * w2;
					comp4.z = key1.transforms[j] * w1 + key2.transforms[j++] * w2;
				} else {
					comp4.x = comp4.y = comp4.z = 1;
				}
				joint.transformMatrix.recompose(components, Orientation3D.QUATERNION);
			}
			var bound:Bound = track.target.bound;
			var min:Vector3D = bound.vertices[0];
			var max:Vector3D = bound.vertices[7];
			min.setTo(key1.bounds[0] * w1 + key2.bounds[0] * w2, key1.bounds[1] * w1 + key2.bounds[1] * w2, key1.bounds[2] * w1 + key2.bounds[2] * w2);
			max.setTo(key1.bounds[3] * w1 + key2.bounds[3] * w2, key1.bounds[4] * w1 + key2.bounds[4] * w2, key1.bounds[5] * w1 + key2.bounds[5] * w2);
			bound.vertices[1].setTo(max.x, min.y, min.z);
			bound.vertices[2].setTo(min.x, max.y, min.z);
			bound.vertices[3].setTo(max.x, max.y, min.z);
			bound.vertices[4].setTo(min.x, min.y, max.z);
			bound.vertices[5].setTo(max.x, min.y, max.z);
			bound.vertices[6].setTo(min.x, max.y, max.z);
			bound.center.setTo((max.x + min.x) * 0.5, (max.y + min.y) * 0.5, (max.z + min.z) * 0.5);
			Joint.calculateMatrixes(skin.root);
			for each(var geom:Geometry in track.target.geometries) {
				b0 = false;
				for each(var vertex:Vertex in geom) {
					if (vertex.indices) {
						b0 = true;
						comp0.x = comp1.x = vertex.x, comp0.y = comp1.y = vertex.y, comp0.z = comp1.z = vertex.z;
						j = vertex.indices.length;
						for (i = 0; i < j; i++) {
							k = vertex.weights[i];
							comp2 = skin.joints[vertex.indices[i]].finalMatrix.transformVector(comp0);
							comp1.x += comp2.x * k, comp1.y += comp2.y * k, comp1.z += comp2.z * k;
						}
						vertex.x = comp1.x, vertex.y = comp1.y, vertex.z = comp1.z;
					}
				}
				if (b0) Geometry.uploadGeometry(geom, true, geom.normalBuffer != null, geom.uvBuffer != null, false);
			}
		}
		
	}

}