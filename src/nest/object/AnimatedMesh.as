package nest.object 
{
	import nest.control.animation.AnimationClip;
	import nest.object.data.MeshData;
	import nest.object.geom.BSphere;
	import nest.object.geom.IBound;
	import nest.view.materials.IMaterial;
	
	/**
	 * AnimatedMesh
	 */
	public class AnimatedMesh extends Mesh 
	{
		
		protected var _clips:Vector.<AnimationClip>
		
		public function AnimatedMesh(data:MeshData, material:IMaterial, bound:IBound=null) 
		{
			super(data, material, bound);
			
		}
		
		override public function clone():IMesh {
			var bound:IBound;
			if (_bound is BSphere) bound = new BSphere();
			var result:AnimatedMesh = new AnimatedMesh(_data, _material, bound);
			result.blendMode.source = _blendMode.source;
			result.blendMode.dest = _blendMode.dest;
			result.blendMode.depthMask = _blendMode.depthMask;
			result.cliping = _cliping;
			result.culling = _culling;
			result.visible = _visible;
			result.alphaTest = _alphaTest;
			if (clips) {
				var l:uint = clips.length;
				var copyClips:Vector.<AnimationClip> = new Vector.<AnimationClip>(l);
				for (var i:int = 0; i < l;i++ ) {
					copyClips[i] = clips[i].clone();
					copyClips[i].target = result;
				}
				result.clips = copyClips;
			}
			return result;
		}
		
		public function get clips():Vector.<AnimationClip> {
			return _clips;
		}
		
		public function set clips(value:Vector.<AnimationClip>):void {
			for each(var clip:AnimationClip in value) {
				clip.target = this;
			}
			_clips = value;
		}
		
	}

}