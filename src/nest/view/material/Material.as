package nest.view.material 
{
	import nest.control.animation.IAnimatable;

	public class Material implements IAnimatable {

		public var textures:Vector.<TextureResource> = new Vector.<TextureResource>();

		private var _track:Vector.<AnimationTrack> = new Vector.<ANimationTrack>();

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get tracks():Vector.<AnimationTrack> {
			return _tracks;
		}

		public function set tracks(value:Vector.<AnimationTrack>):void {
			_tracks = value;
		}

	}
}