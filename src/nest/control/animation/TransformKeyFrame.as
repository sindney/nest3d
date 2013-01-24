package nest.control.animation 
{
	import flash.geom.Vector3D;
	
	import nest.object.IObject3D;
	
	/**
	 * TransformKeyFrame
	 */
	public class TransformKeyFrame implements IKeyFrame {
		
		public static function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var result:TransformKeyFrame = new TransformKeyFrame();
			result.time = k1.time * w1 + w2 * k2.time;
			result.position.setTo(k1.position.x * w1 + k2.position.x * w2, k1.position.y * w1 + k2.position.y * w2, k1.position.z * w1 + k2.position.z * w2);
			result.rotation.setTo(k1.rotation.x * w1 + k2.rotation.x * w2, k1.rotation.y * w1 + k2.rotation.y * w2, k1.rotation.z * w1 + k2.rotation.z * w2);
			result.scale.setTo(k1.scale.x * w1 + k2.scale.x * w2, k1.scale.y * w1 + k2.scale.y * w2, k1.scale.z * w1 + k2.scale.z * w2);
			return result;
		}
		
		public static function calculate(target:IAnimatable, root:IKeyFrame, time:Number):void {
			var frame:IKeyFrame = root;
			var timeOffset:Number;
			
			while (frame && time >= frame.time) {
				timeOffset = frame.time;
				frame = frame.next;
			}
			
			if (frame) {
				var weight2:Number = (time - timeOffset) / (frame.time - timeOffset);
				var weight1:Number = 1 - weight2;
				if (!weight1) {
					weight1 = 1;
					weight2 = 0;
				}
				if (frame.next) {
					var object:IObject3D = target as IObject3D;
					var curTrans:TransformKeyFrame = frame as TransformKeyFrame;
					var nextTrans:TransformKeyFrame = frame.next as TransformKeyFrame;
					
					object.position.setTo(curTrans.position.x * weight1 + nextTrans.position.x * weight2,
										curTrans.position.y * weight1 + nextTrans.position.y * weight2,
										curTrans.position.z * weight1 + nextTrans.position.z * weight2);
					object.rotation.setTo(curTrans.rotation.x * weight1 + nextTrans.rotation.x * weight2,
										curTrans.rotation.y * weight1 + nextTrans.rotation.y * weight2,
										curTrans.rotation.z * weight1 + nextTrans.rotation.z * weight2);
					object.scale.setTo(curTrans.scale.x * weight1 + nextTrans.scale.x * weight2,
										curTrans.scale.y * weight1 + nextTrans.scale.y * weight2,
										curTrans.scale.z * weight1 + nextTrans.scale.z * weight2);
					
					object.recompose();
				}
			}
		}
		
		private var _time:Number;
		private var _name:String;
		private var _next:IKeyFrame;
		
		public var position:Vector3D;
		
		public var rotation:Vector3D;
		
		public var scale:Vector3D;
		
		public function TransformKeyFrame() {
			position = new Vector3D();
			rotation = new Vector3D();
			scale = new Vector3D();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(value:Number):void {
			_time = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get next():IKeyFrame {
			return _next;
		}
		
		public function set next(value:IKeyFrame):void {
			_next = value;
		}
	}

}