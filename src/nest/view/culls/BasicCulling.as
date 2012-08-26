package nest.view.culls 
{
	import flash.geom.Vector3D;
	
	import nest.control.EngineBase;
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.view.Camera3D;
	
	/**
	 * BasicCulling
	 */
	public class BasicCulling implements ICulling {
		
		protected var vertices:Vector.<Vector3D>;
		
		public function BasicCulling() {
			vertices = new Vector.<Vector3D>(9, true);
			vertices[0] = new Vector3D();
			vertices[1] = new Vector3D();
			vertices[2] = new Vector3D();
			vertices[3] = new Vector3D();
			vertices[4] = new Vector3D();
			vertices[5] = new Vector3D();
			vertices[6] = new Vector3D();
			vertices[7] = new Vector3D();
			vertices[8] = new Vector3D();
		}
		
		public function classifyMesh(mesh:IMesh):Boolean {
			var camera:Camera3D = EngineBase.camera;
			var i:int;
			var v:Vector3D = new Vector3D();
			if (mesh.bound is AABB) {
				for (i = 0; i < 8; i++) {
					v.copyFrom((mesh.bound as AABB).vertices[i]);
					v.copyFrom(camera.invertMatrix.transformVector(mesh.matrix.transformVector(v)));
					vertices[i].copyFrom(v);
				}
				return camera.frustum.classifyAABB(vertices);
			}
			
			// BoundingShpere
			i = mesh.scale.x > mesh.scale.y ? mesh.scale.x : mesh.scale.y;
			if (mesh.scale.z > i) i = mesh.scale.z;
			v.copyFrom(camera.invertMatrix.transformVector(mesh.matrix.transformVector(mesh.bound.center)));
			return camera.frustum.classifyBSphere(v, (mesh.bound as BSphere).radius * i);
		}
		
		public function classifyContainer(container:IContainer3D):Boolean {
			return container.visible;
		}
		
	}

}