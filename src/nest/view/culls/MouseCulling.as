package nest.view.culls 
{
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	
	/**
	 * MouseCulling
	 */
	public class MouseCulling implements ICulling {
		
		public function MouseCulling() {
			
		}
		
		public function classifyMesh(mesh:IMesh):Boolean {
			return mesh.mouseEnabled;
		}
		
		public function classifyContainer(container:IContainer3D):Boolean {
			return container.mouseEnabled;
		}
		
	}

}