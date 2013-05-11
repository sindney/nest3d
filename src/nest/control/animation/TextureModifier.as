package nest.control.animation 
{
	import nest.view.TextureResource;
	
	/**
	 * TextureModifier
	 */
	public class TextureModifier implements IAnimationModifier {
		
		public static const SHADER_INDEX:String = "shader_index";
		public static const TEXTURE_INDEX:String = "texture_index";
		
		public function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void {
			var key:TextureKeyFrame = k1 as TextureKeyFrame;
			track.target.shaders[track.parameters[SHADER_INDEX]].texturesPart[track.parameters[TEXTURE_INDEX]].texture = key.data;
		}
		
	}

}