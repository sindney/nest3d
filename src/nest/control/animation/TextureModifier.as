package nest.control.animation 
{
	import nest.view.TextureResource;
	
	/**
	 * TextureModifier
	 */
	public class TextureModifier implements IAnimationModifier {
		
		public static const instance:IAnimationModifier = new TextureModifier();
		
		public static const TEXTURE_INDEX:String = "texture_index";
		
		public function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void {
			var key:TextureKeyFrame = k1 as TextureKeyFrame;
			track.target.shader.texturesPart[track.parameters[TEXTURE_INDEX]].texture = key.data;
		}
		
	}

}