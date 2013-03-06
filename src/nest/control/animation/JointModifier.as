package nest.control.animation 
{
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	import nest.control.util.Quaternion;
	import nest.object.geom.Bound;
	import nest.object.geom.SkinInfo;
	import nest.object.geom.Joint;
	
	/**
	 * JointModifier
	 */
	public class JointModifier implements IAnimationModifier {
		
		public function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void {
			var w1:Number = track.weight * (k2.time - time) / (k2.time - k1.time);
			var w2:Number = track.weight - w1;
			var key1:JointKeyFrame = k1 as JointKeyFrame;
			var key2:JointKeyFrame = k2 as JointKeyFrame;
			var position:Vector3D = new Vector3D(), rotation:Vector3D = new Vector3D();
			var rotation0:Vector3D = new Vector3D(), rotation1:Vector3D = new Vector3D();
			var components:Vector.<Vector3D> = Vector.<Vector3D>([position, rotation, new Vector3D(1, 1, 1)]);
			var skin:SkinInfo = track.target.skinInfo;
			var bound:Bound = track.target.bound;
			var i:int, j:int, k:int = skin.joints.length;
			var joint:Joint;
			for (i = 0; i < k; i++) {
				joint = skin.joints[i];
				j = i * 6;
				position.x = key1.positions[j] * w1 + key2.positions[j] * w2;
				position.y = key1.positions[j + 1] * w1 + key2.positions[j + 1] * w2;
				position.z = key1.positions[j + 2] * w1 + key2.positions[j + 2] * w2;
				j = i * 8;
				rotation0.x = key1.rotations[j], rotation0.y = key1.rotations[j + 1], rotation0.z = key1.rotations[j + 2], rotation0.w = key1.rotations[j + 3];
				rotation1.x = key2.rotations[j], rotation1.y = key2.rotations[j + 1], rotation1.z = key2.rotations[j + 2], rotation1.w = key2.rotations[j + 3];
				Quaternion.slerp(rotation0, rotation1, w2, rotation);
				joint.transformMatrix.recompose(components, Orientation3D.QUATERNION);
			}
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
			// 根据skinInfo的骨骼结构，从skinInfo.root链表更新骨骼的变换矩阵
			Joint.calculateMatrixes(skin.root, track.target.matrix);
			// 更新顶点位置，并上传之
		}
		
	}

}