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
		
		public static function interpolate(k1:KeyFrame, k2:KeyFrame, w:Number):KeyFrame {
			var result:VertexKeyFrame = new VertexKeyFrame();
			var v_k1:VertexKeyFrame = k1 as VertexKeyFrame;
			var v_k2:VertexKeyFrame = k2 as VertexKeyFrame;
			result.time = v_k1.time * w + (1 - w) * v_k2.time;
			result.next = v_k2;
			if (v_k1.vertices && v_k2.vertices) {
				var l:uint = v_k1.vertices.length;
				var copy_vertices:Vector.<Number> = new Vector.<Number>(l);
				for (var i:int = 0; i < l;i++ ) {
					copy_vertices[i] = v_k1.vertices[i] * w + v_k2.vertices[i] * (1 - w);
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