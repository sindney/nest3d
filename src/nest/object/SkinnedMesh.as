package nest.object 
{
	import flash.utils.Dictionary;
	
	import nest.object.data.MeshData;
	import nest.object.geom.BSphere;
	import nest.object.geom.IBound;
	import nest.object.geom.Joint;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.view.materials.IMaterial;
	import nest.view.Shader3D;
	
	/**
	 * SkinnedMesh
	 */
	public class SkinnedMesh extends Mesh {
		
		public var joint:Joint;
		public var joints:Vector.<Joint>;
		public var vertices:Vector.<Vertex>;
		
		public var tracks:Dictionary;
		
		public function SkinnedMesh(data:MeshData, material:IMaterial, shader:Shader3D, bound:IBound = null) {
			super(data, material, shader, bound);
		}
		
		override public function clone():IMesh {
			var bound:IBound;
			if (_bound is BSphere) bound = new BSphere(); 
			var result:SkinnedMesh = new SkinnedMesh(_data, _material, _shader, bound);
			result.blendMode.source = _blendMode.source;
			result.blendMode.dest = _blendMode.dest;
			result.blendMode.depthMask = _blendMode.depthMask;
			result.cliping = _cliping;
			result.culling = _culling;
			result.visible = _visible;
			result.joint = joint;
			result.joints = joints;
			result.vertices = vertices;
			result.tracks = tracks;
			return result;
		}
		
	}

}