package nest.control 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.data.AnimationTrack;;
	import nest.object.data.JointLinker;
	import nest.object.geom.Joint;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.SkinnedMesh;
	
	/**
	 * AnimationController
	 */
	public class AnimationController {
		
		private const matrix:Matrix3D = new Matrix3D();
		
		public var time:Number;
		public var advanceTime:Number;
		
		public var track:AnimationTrack;
		
		public var target:SkinnedMesh;
		
		public function AnimationController() {
			matrix.identity();
		}
		
		public function update():void {
			if (!target && !track) return;
			if (time > track.end || time < track.start) time = track.start;
			
			// update joints
			target.joint.update(matrix, time);
			
			// update vertices
			var i:int, j:int = target.data.numVertices;
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var v2:Vector3D = new Vector3D();
			var v3:Vector3D = new Vector3D();
			var vt0:Vertex;
			var linker:JointLinker;
			for (i = 0; i < j; i++) {
				vt0 = target.vertices[i];
				v0.setTo(vt0.x, vt0.y, vt0.z);
				v2.setTo(0, 0, 0);
				v3.setTo(0, 0, 0);
				linker = vt0.linker;
				while (linker) {
					v1 = linker.joint.result.transformVector(v0);
					v1.scaleBy(linker.weight);
					v2.add(v1);
					v1 = linker.joint.result.transformVector(vt0.normal);
					v1.scaleBy(linker.weight);
					v3.add(v1);
					linker = linker.next;
				}
				vt0 = target.data.vertices[i];
				vt0.x = v2.x;
				vt0.y = v2.y;
				vt0.z = v2.z;
				vt0.normal.setTo(v3.x, v3.y, v3.z);
			}
			
			var triangle:Triangle;
			var vt1:Vertex, vt2:Vertex;
			j = target.data.numTriangles;
			for (i = 0; i < j; i++) {
				triangle = target.data.triangles[i];
				vt0 = vertices[triangle.index0];
				vt1 = vertices[triangle.index1];
				vt2 = vertices[triangle.index2];
				v0.setTo(vt1.x - vt0.x, vt1.y - vt0.y, vt1.z - vt0.z);
				v1.setTo(vt2.x - vt1.x, vt2.y - vt1.y, vt2.z - vt1.z);
				triangle.normal.copyFrom(v0.crossProduct(v1));
				triangle.normal.normalize();
			}
			
			target.data.update();
			
			time += advanceTime;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.control.AnimationController]";
		}
	}

}