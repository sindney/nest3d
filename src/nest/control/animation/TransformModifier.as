package nest.control.animation 
{
	import nest.control.util.Quaternion;
	import nest.object.IMesh;
	
	/**
	 * TransformModifier
	 */
	public class TransformModifier implements IAnimationModifier {
		
		public function calculate(target:IMesh, k1:IKeyFrame, k2:IKeyFrame, time:Number, weight:Number):void {
			var w1:Number = weight * (k2.time - time) / (k2.time - k1.time);
			var w2:Number = weight - w1;
			
			var key1:TransformKeyFrame = k1 as TransformKeyFrame;
			var key2:TransformKeyFrame = k2 as TransformKeyFrame;
			
			target.position.setTo(key1.position.x * w1 + key2.position.x * w2,
								key1.position.y * w1 + key2.position.y * w2,
								key1.position.z * w1 + key2.position.z * w2);
			target.scale.setTo(key1.scale.x * w1 + key2.scale.x * w2,
								key1.scale.y * w1 + key2.scale.y * w2,
								key1.scale.z * w1 + key2.scale.z * w2);
			Quaternion.slerp(key1.rotation, key2.rotation, w2, target.rotation);
			
			target.recompose();
		}
		
	}

}