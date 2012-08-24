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
			var result:Boolean = mesh.mouseEnabled;
			if (result) {
				var parent:IContainer3D = mesh.parent;
				while (parent) {
					result = parent.mouseEnabled;
					if (!result) return false;
					parent = parent.parent;
				}
			}
			return result;
		}
		
		public function classifyContainer(container:IContainer3D):Boolean {
			return container.mouseEnabled;
		}
		
	}

}