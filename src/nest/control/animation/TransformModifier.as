package nest.control.animation 
{
	import nest.object.IObject3D;
	
	/**
	 * TransformModifier
	 */
	public class TransformModifier implements IAnimationModifier {
		
		public function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var tk1:TransformKeyFrame = k1 as TransformKeyFrame;
			var tk2:TransformKeyFrame = k2 as TransformKeyFrame;
			var result:TransformKeyFrame = new TransformKeyFrame();
			result.time = tk1.time * w1 + w2 * tk2.time;
			result.position.setTo(tk1.position.x * w1 + tk2.position.x * w2, tk1.position.y * w1 + tk2.position.y * w2, tk1.position.z * w1 + tk2.position.z * w2);
			result.rotation.setTo(tk1.rotation.x * w1 + tk2.rotation.x * w2, tk1.rotation.y * w1 + tk2.rotation.y * w2, tk1.rotation.z * w1 + tk2.rotation.z * w2);
			result.scale.setTo(tk1.scale.x * w1 + tk2.scale.x * w2, tk1.scale.y * w1 + tk2.scale.y * w2, tk1.scale.z * w1 + tk2.scale.z * w2);
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
			
			var object:IObject3D = target as IObject3D;
			var curTrans:TransformKeyFrame = frame as TransformKeyFrame;
			var nextTrans:TransformKeyFrame = frame.next as TransformKeyFrame;
			
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