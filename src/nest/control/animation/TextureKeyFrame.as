package nest.control.animation 
{
	import flash.display.BitmapData;
	
	/**
	 * TextureKeyFrame
	 */
	public class TextureKeyFrame implements IKeyFrame {
		
		public var data:BitmapData;
		public var index:int;
		
		private var _time:Number;
		private var _name:String;
		private var _next:IKeyFrame;
		
		public function TextureKeyFrame() {
			
		}
		
		public function clone():IKeyFrame {
			var result:TextureKeyFrame = new TextureKeyFrame();
			result.time = _time;
			result.name = _name;
			result.data = data;
			result.index = index;
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