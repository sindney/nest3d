package nest.control.animation 
{
	import nest.object.IMesh;
	
	/**
	 * UVModifier
	 */
	public class UVModifier implements IAnimationModifier {
		
		public function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var tmp:UVKeyFrame = k2 as UVKeyFrame;
			var result:UVKeyFrame = new UVKeyFrame();
			result.time = k1.time * w1 + w2 * tmp.time;
			if (k1.uvs && tmp.uvs) {
				var l:uint = k1.uvs.length;
				var copy:Vector.<Number> = new Vector.<Number>(l);
				for (var i:int = 0; i < l;i++ ) {
					copy[i] = k1.uvs[i] * w1 + tmp.uvs[i] * w2;
				}
				result.uvs = copy;
			}
			return result;
		}
		
		public function calculate(target:IAnimatable, root:IKeyFrame, time:Number):void {
			var frame:IKeyFrame = root;
			var offset:Number = root.next.time;
			
			while (time >= frame.next.time) {
				frame = frame.next;
				offset = frame.next.time;
			}
			
			var w1:Number = (offset - time) / (offset - frame.time);
			var w2:Number = 1 - w1;
			
			var mesh:IMesh = target as IMesh;
			var curUVs:Vector.<Number> = (frame as UVKeyFrame).uvs;
			var nextUVs:Vector.<Number> = (frame.next as UVKeyFrame).uvs;
			var l:int = curVertices.length / 2;
			var i:int;
			for (i = 0; i < l; i++ ) {
				mesh.geom.vertices[i].u = curUVs[i << 1] * w1 + nextUVs[i << 1] * w2;
				mesh.geom.vertices[i].v = curUVs[(i << 1) + 1] * w1 + nextUVs[(i << 1) + 1] * w2;
			}
			mesh.geom.update(false);
		}
		
	}

}