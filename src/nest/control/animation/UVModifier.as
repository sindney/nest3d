package nest.control.animation 
{
	import nest.object.IMesh;
	
	/**
	 * UVModifier
	 */
	public class UVModifier implements IAnimationModifier {
		
		public function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var tk1:UVKeyFrame = k1 as UVKeyFrame;
			var tk2:UVKeyFrame = k2 as UVKeyFrame;
			var result:UVKeyFrame = new UVKeyFrame();
			result.time = tk1.time * w1 + w2 * tk2.time;
			if (tk1.uvs && tk2.uvs) {
				var l:uint = tk1.uvs.length;
				var copy:Vector.<Number> = new Vector.<Number>(l, true);
				for (var i:int = 0; i < l;i++ ) {
					copy[i] = tk1.uvs[i] * w1 + tk2.uvs[i] * w2;
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
			var l:int = curUVs.length / 2;
			var i:int, j:int;
			for (i = 0, j = 0; i < l; i++, j += 2) {
				mesh.geom.vertices[i].u = curUVs[j] * w1 + nextUVs[j] * w2;
				mesh.geom.vertices[i].v = curUVs[j + 1] * w1 + nextUVs[j + 1] * w2;
			}
			mesh.geom.update(false);
		}
		
	}

}