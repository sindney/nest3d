package nest.control.animation 
{
	import flash.geom.Vector3D;
	
	/**
	 * TransformKeyFrame
	 */
	public class TransformKeyFrame implements IKeyFrame {
		
		private var _time:Number;
		private var _name:String;
		
		public var position:Vector3D = new Vector3D();
		public var rotation:Vector3D = new Vector3D(0, 0, 0, 1);
		public var scale:Vector3D = new Vector3D(1, 1, 1);
		
		public function clone():IKeyFrame {
			var result:TransformKeyFrame = new TransformKeyFrame();
			result.time = _time;
			result.name = _name;
			result.position.copyFrom(position);
			result.rotation.copyFrom(rotation);
			result.scale.copyFrom(scale);
			return result;
		}
		
		public function dispose():void {
			position = null;
			rotation = null;
			scale = null;
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
		
	}

}