package nest.control.animation 
{
	import flash.geom.Vector3D;
	
	/**
	 * TransformKeyFrame
	 */
	public class TransformKeyFrame extends KeyFrame {
		
		public var position:Vector3D;
		
		public var rotation:Vector3D;
		
		public var scale:Vector3D;
		
		public function TransformKeyFrame() {
			position = new Vector3D();
			rotation = new Vector3D();
			scale = new Vector3D();
		}
		
		public static function interpolate(k1:TransformKeyFrame, k2:TransformKeyFrame, w1:Number, w2:Number):TransformKeyFrame {
			if (!k2) return k1.clone() as TransformKeyFrame;
			var result:TransformKeyFrame = new TransformKeyFrame();
			result.time = k1.time * w1 + w2 * k2.time;
			
			result.position.setTo(k1.position.x * w1 + k2.position.x * w2, k1.position.y * w1 + k2.position.y * w2, k1.position.z * w1 + k2.position.z * w2);
			result.rotation.setTo(k1.rotation.x * w1 + k2.rotation.x * w2, k1.rotation.y * w1 + k2.rotation.y * w2, k1.rotation.z * w1 + k2.rotation.z * w2);
			result.scale.setTo(k1.scale.x * w1 + k2.scale.x * w2, k1.scale.y * w1 + k2.scale.y * w2, k1.scale.z * w1 + k2.scale.z * w2);
			return result;
		}
		
		override public function clone():KeyFrame {
			var result:TransformKeyFrame = new TransformKeyFrame();
			result.time = time;
			result.name = name;
			result.next = next;
			
			result.position.copyFrom(position);
			result.rotation.copyFrom(rotation);
			result.scale.copyFrom(scale);
			
			return result;
		}
	}

}