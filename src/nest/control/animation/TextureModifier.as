package nest.control.animation 
{
	import nest.view.TextureResource;
	
	/**
	 * TextureModifier
	 */
	public class TextureModifier implements IAnimationModifier {
		
		public static const MATERIAL_INDEX:String = "material_index";
		public static const TEXTURE_INDEX:String = "texture_index";
		
		public function calculate(track:AnimationTrack, k1:IKeyFrame, k2:IKeyFrame, time:Number):void {
			var key:TextureKeyFrame = k1 as TextureKeyFrame;
			TextureResource.uploadToTexture(track.target.materials[track.parameters[MATERIAL_INDEX]][track.parameters[TEXTURE_INDEX]], key.data, key.mipmapping);
		}
		
	}

}