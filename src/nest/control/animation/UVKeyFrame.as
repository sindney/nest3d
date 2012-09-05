package nest.control.animation 
{
	/**
	 * UVKeyFrame
	 */
	public class UVKeyFrame extends KeyFrame 
	{
		/**
		 * Store the u,v in order.
		 */
		public var uvs:Vector.<Number>;
		
		public function UVKeyFrame() 
		{
			
		}
		
		public static function interpolate(k1:UVKeyFrame, k2:UVKeyFrame, w1:Number, w2:Number):UVKeyFrame {
			if (!k2) return k1.clone() as UVKeyFrame;
			var result:UVKeyFrame = new UVKeyFrame();
			result.time = k1.time * w1 + w2 * k2.time;
			if (k1.uvs && k2.uvs) {
				var l:uint = k1.uvs.length;
				var copy_uvs:Vector.<Number> = new Vector.<Number>(l);
				for (var i:int = 0; i < l;i++ ) {
					copy_uvs[i] = k1.uvs[i] * w1 + k2.uvs[i] * w2;
				}
				result.uvs = copy_uvs;
			}
			return result;
		}
		
		override public function clone():KeyFrame {
			var result:UVKeyFrame = new UVKeyFrame();
			result.time = time;
			result.name = name;
			result.next = next;
			if (uvs) {
				result.uvs = uvs.concat();
			}
			return result;
		}
	}

}