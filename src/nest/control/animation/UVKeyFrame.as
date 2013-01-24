package nest.control.animation 
{
	import nest.object.IMesh;
	
	/**
	 * UVKeyFrame
	 */
	public class UVKeyFrame implements IKeyFrame {
		
		public static function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var result:UVKeyFrame = new UVKeyFrame();
			result.time = k1.time * w1 + w2 * k2.time;
			if (k1.uvs && k2.uvs) {
				var l:uint = k1.uvs.length;
				var copy:Vector.<Number> = new Vector.<Number>(l);
				for (var i:int = 0; i < l;i++ ) {
					copy[i] = k1.uvs[i] * w1 + k2.uvs[i] * w2;
				}
				result.uvs = copy;
			}
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
					var mesh:IMesh = target as IMesh;
					var curUVs:Vector.<Number> = (frame as UVKeyFrame).uvs;
					var nextUVs:Vector.<Number> = (frame.next as UVKeyFrame).uvs;
					var l:int = curVertices.length / 2;
					var i:int;
					for (i = 0; i < l; i++ ) {
						mesh.geom.vertices[i].u = curUVs[i << 1] * weight1 + nextUVs[i << 1] * weight2;
						mesh.geom.vertices[i].v = curUVs[(i << 1) + 1] * weight1 + nextUVs[(i << 1) + 1] * weight2;
					}
					mesh.geom.update(false);
				}
			}
		}
		
		private var _time:Number;
		private var _name:String;
		private var _next:IKeyFrame;
		
		public var uvs:Vector.<Number>;
		
		public function UVKeyFrame() {
			
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