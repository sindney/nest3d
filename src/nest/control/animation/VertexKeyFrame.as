package nest.control.animation 
{
	/**
	 * VertexKeyFrame
	 */
	public class VertexKeyFrame extends KeyFrame 
	{
		/**
		 * Store the x,y,z in order.
		 */
		public var vertices:Vector.<Number>;
		
		public function VertexKeyFrame() 
		{
			
		}
		
		public static function interpolate(k1:VertexKeyFrame, k2:VertexKeyFrame, w1:Number, w2:Number):VertexKeyFrame {
			if (!k2) return k1.clone() as VertexKeyFrame;
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
		
		override public function clone():KeyFrame {
			var result:VertexKeyFrame = new VertexKeyFrame();
			result.time = time;
			result.name = name;
			result.next = next;
			if (vertices) {
				result.vertices = vertices.concat();
			}
			return result;
		}
	}

}