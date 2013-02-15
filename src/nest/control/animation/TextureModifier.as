package nest.control.animation 
{
	import nest.control.util.TextureUtil;
	import nest.view.material.Material;
	
	/**
	 * TextureModifier
	 */
	public class TextureModifier implements IAnimationModifier {
		
		public function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var tk1:TextureKeyFrame = k1 as TextureKeyFrame;
			var tk2:TextureKeyFrame = k2 as TextureKeyFrame;
			var result:TextureKeyFrame = new TextureKeyFrame();
			result.time = tk1.time * w1 + w2 * tk2.time;
			result.data = tk1.data;
			result.index = tk1.index;
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
			
			var material:Material = target as Material;
			var current:TextureKeyFrame = frame as TextureKeyFrame;
			TextureUtil.uploadToTexture(material.textures[current.index], current.data, false);
		}
		
	}

}