package nest.control.animation 
{
	import nest.object.IMesh;
	import nest.view.TextureResource;
	
	/**
	 * TextureModifier
	 */
	public class TextureModifier implements IAnimationModifier {
		
		public function calculate(target:IMesh, k1:IKeyFrame, k2:IKeyFrame, time:Number, weight:Number):void {
			var key:TextureKeyFrame = k1 as TextureKeyFrame;
			TextureResource.uploadToTexture(target.material[key.index], key.data, key.mipmapping);
		}
		
	}

}