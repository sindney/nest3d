package nest.control.animation 
{
	
	/**
	 * JointKeyFrame
	 */
	public class JointKeyFrame implements IKeyFrame {
		
		private var _time:Number;
		private var _name:String;
		
		public var bounds:Vector.<Number> = new Vector.<Number>(6, true);
		public var transforms:Vector.<Number> = new Vector.<Number>();
		
		public function clone():IKeyFrame {
			var result:JointKeyFrame = new JointKeyFrame();
			result.time = _time;
			result.name = _name;
			var i:int, j:int = transforms.length;
			for (i = 0; i < 6; i++) result.bounds[i] = bounds[i];
			for (i = 0; i < j; i++) result.transforms[i] = transforms[i];
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
	}

}