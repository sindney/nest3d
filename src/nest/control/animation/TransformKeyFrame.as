package nest.control.animation 
{
	import flash.geom.Vector3D;
	
	/**
	 * TransformKeyFrame
	 */
	public class TransformKeyFrame implements IKeyFrame {
		
		private var _time:Number;
		private var _name:String;
		private var _next:IKeyFrame;
		
		public var position:Vector3D;
		
		public var rotation:Vector3D;
		
		public var scale:Vector3D;
		
		public function TransformKeyFrame() {
			position = new Vector3D();
			rotation = new Vector3D();
			scale = new Vector3D(1, 1, 1);
		}
		
		public function clone():IKeyFrame {
			var result:TransformKeyFrame = new TransformKeyFrame();
			result.time = _time;
			result.name = _name;
			result.position.copyFrom(position);
			result.rotation.copyFrom(rotation);
			result.scale.copyFrom(scale);
			return result;
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