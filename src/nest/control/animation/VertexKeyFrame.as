package nest.control.animation 
{
	
	/**
	 * VertexKeyFrame
	 */
	public class VertexKeyFrame implements IKeyFrame {
		
		private var _time:Number;
		private var _name:String;
		
		public var bounds:Vector.<Number> = new Vector.<Number>(6, true);
		public var vertices:Vector.<Number>;
		public var normals:Vector.<Number>;
		public var tangents:Vector.<Number>;
		
		public function clone():IKeyFrame {
			var result:VertexKeyFrame = new VertexKeyFrame();
			result.time = _time;
			result.name = _name;
			var i:int, j:int;
			for (i = 0; i < 6; i++) result.bounds[i] = bounds[i];
			if (vertices) {
				j = vertices.length;
				for (i = 0; i < j; i++) result.vertices[i] = vertices[i];
			}
			if (normals) {
				j = normals.length;
				for (i = 0; i < j; i++) result.normals[i] = normals[i];
			}
			if (tangents) {
				j = tangents.length;
				for (i = 0; i < j; i++) result.tangents[i] = tangents[i];
			}
			return result;
		}
		
		public function dispose():void {
			bounds = null;
			vertices = null;
			normals = null;
			tangents = null;
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