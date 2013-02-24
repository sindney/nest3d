package nest.control.animation 
{
	
	/**
	 * VertexKeyFrame
	 */
	public class VertexKeyFrame implements IKeyFrame {
		
		private var _time:Number;
		private var _name:String;
		
		public var vertices:Vector.<Number>;
		public var normals:Vector.<Number>;
		
		public function clone():IKeyFrame {
			var result:VertexKeyFrame = new VertexKeyFrame();
			result.time = _time;
			result.name = _name;
			result.vertices = vertices;
			result.normals = normals;
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