package nest.control.animation 
{
	
	/**
	 * UVKeyFrame
	 */
	public class UVKeyFrame implements IKeyFrame {
		
		private var _time:Number;
		private var _name:String;
		private var _next:IKeyFrame;
		
		public var uvs:Vector.<Number>;
		
		public function UVKeyFrame() {
			
		}
		
		public function clone():IKeyFrame {
			var result:UVKeyFrame = new UVKeyFrame();
			result.time = _time;
			result.name = _name;
			result.uvs = uvs;
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