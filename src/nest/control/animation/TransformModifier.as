package nest.control.animation 
{
	import nest.object.IMesh;
	import nest.object.IObject3D;
	
	/**
	 * TransformModifier
	 */
	public class TransformModifier implements IAnimationModifier {
		
		public function calculate(target:IMesh, root:IKeyFrame, time:Number):void {
			var frame:IKeyFrame = root;
			var offset:Number = root.next.time;
			
			while (time >= frame.next.time) {
				frame = frame.next;
				offset = frame.next.time;
			}
			
			var w1:Number = (offset - time) / (offset - frame.time);
			var w2:Number = 1 - w1;
			
			var object:IObject3D = target as IObject3D;
			var curTrans:TransformKeyFrame = frame as TransformKeyFrame;
			var nextTrans:TransformKeyFrame = frame.next as TransformKeyFrame;
			// TODO: 使用四元数进行旋转的插值运算
			object.position.setTo(curTrans.position.x * w1 + nextTrans.position.x * w2,
								curTrans.position.y * w1 + nextTrans.position.y * w2,
								curTrans.position.z * w1 + nextTrans.position.z * w2);
			object.rotation.setTo(curTrans.rotation.x * w1 + nextTrans.rotation.x * w2,
								curTrans.rotation.y * w1 + nextTrans.rotation.y * w2,
								curTrans.rotation.z * w1 + nextTrans.rotation.z * w2);
			object.scale.setTo(curTrans.scale.x * w1 + nextTrans.scale.x * w2,
								curTrans.scale.y * w1 + nextTrans.scale.y * w2,
								curTrans.scale.z * w1 + nextTrans.scale.z * w2);
			
			object.recompose();
		}
		
	}

}