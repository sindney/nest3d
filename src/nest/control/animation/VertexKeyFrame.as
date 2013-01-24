package nest.control.animation 
{
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	
	/**
	 * VertexKeyFrame
	 */
	public class VertexKeyFrame implements IKeyFrame {
		
		public static function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var result:VertexKeyFrame = new VertexKeyFrame();
			result.time = k1.time * w1 + w2 * k2.time;
			if (k1.vertices && k2.vertices) {
				var l:uint = k1.vertices.length;
				var copy_vertices:Vector.<Number> = new Vector.<Number>(l);
				for (var i:int = 0; i < l;i++ ) {
					copy_vertices[i] = k1.vertices[i] * w1 + k2.vertices[i] * w2;
				}
				result.vertices = copy_vertices;
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
					var curVertices:Vector.<Number> = (frame as VertexKeyFrame).vertices;
					var nextVertices:Vector.<Number> = (frame.next as VertexKeyFrame).vertices;
					var i:int, j:int;
					var l:int = curVertices.length / 3;
					for (i = 0, j = 0; i < l; i++, j += 3) {
						var vertex:Vertex = mesh.geom.vertices[i];
						vertex.x = curVertices[j] * weight1 + nextVertices[j] * weight2;
						vertex.y = curVertices[j + 1] * weight1 + nextVertices[j + 1] * weight2;
						vertex.z = curVertices[j + 2] * weight1 + nextVertices[j + 2] * weight2;
						// TODO: 更新vertex normal在这里
					}
					mesh.geom.update(false);
				}
			}
		}
		
		private var _time:Number;
		private var _name:String;
		private var _next:IKeyFrame;
		
		public var vertices:Vector.<Number>;
		public var normals:Vector.<Number>;
		
		public function VertexKeyFrame() {
			
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