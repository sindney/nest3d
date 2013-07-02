package nest.control.animation 
{
	import nest.control.util.Quaternion;
	
	/**
	 * TransformModifier
	 */
	public class TransformModifier implements IAnimationModifier {
		
		public static const instance:IAnimationModifier = new TransformModifier();
		
		public function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void {
			var w1:Number = track.weight * (k2.time - time) / (k2.time - k1.time);
			var w2:Number = track.weight - w1;
			
			var key1:TransformKeyFrame = k1 as TransformKeyFrame;
			var key2:TransformKeyFrame = k2 as TransformKeyFrame;
			
			track.target.position.setTo(key1.position.x * w1 + key2.position.x * w2,
									key1.position.y * w1 + key2.position.y * w2,
									key1.position.z * w1 + key2.position.z * w2);
			track.target.scale.setTo(key1.scale.x * w1 + key2.scale.x * w2,
									key1.scale.y * w1 + key2.scale.y * w2,
									key1.scale.z * w1 + key2.scale.z * w2);
			Quaternion.slerp(key1.rotation, key2.rotation, w2, track.target.rotation);
			
			track.target.recompose();
		}
		
	}

}