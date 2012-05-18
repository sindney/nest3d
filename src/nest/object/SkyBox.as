package nest.object 
{
	import nest.control.factories.PrimitiveFactory;
	import nest.object.data.MeshData;
	import nest.view.materials.IMaterial;
	import nest.view.Shader3D;
	
	/**
	 * SkyBox
	 */
	public class SkyBox extends Container3D {
		
		public static const TOP:int = 0;
		public static const BOTTOM:int = 1;
		public static const LEFT:int = 2;
		public static const RIGHT:int = 3;
		public static const FRONT:int = 4;
		public static const BACK:int = 5;
		
		private var _planes:Vector.<Mesh>;
		
		public function SkyBox(size:Number, materials:Vector.<IMaterial>, shader:Shader3D) {
			super();
			
			_planes = new Vector.<Mesh>(6, true);
			
			var size2:Number = size / 2;
			var mesh:Mesh;
			var data:MeshData = PrimitiveFactory.createPlane(size, size);
			
			mesh = new Mesh(data, materials[TOP], shader);
			mesh.position.y = size2;
			mesh.rotation.x = Math.PI;
			mesh.changed = true;
			addChild(mesh);
			_planes[TOP] = mesh;
			
			mesh = new Mesh(data, materials[BOTTOM], shader);
			mesh.position.y = -size2;
			mesh.changed = true;
			addChild(mesh);
			_planes[BOTTOM] = mesh;
			
			mesh = new Mesh(data, materials[LEFT], shader);
			mesh.position.x = -size2;
			mesh.rotation.y = -Math.PI / 2;
			mesh.rotation.z = -Math.PI / 2;
			mesh.changed = true;
			addChild(mesh);
			_planes[LEFT] = mesh;
			
			mesh = new Mesh(data, materials[RIGHT], shader);
			mesh.position.x = size2;
			mesh.rotation.y = Math.PI / 2;
			mesh.rotation.z = Math.PI / 2;
			mesh.changed = true;
			addChild(mesh);
			_planes[RIGHT] = mesh;
			
			mesh = new Mesh(data, materials[FRONT], shader);
			mesh.position.z = size2;
			mesh.rotation.x = -Math.PI / 2;
			mesh.changed = true;
			addChild(mesh);
			_planes[FRONT] = mesh;
			
			mesh = new Mesh(data, materials[BACK], shader);
			mesh.position.z = -size2;
			mesh.rotation.x = Math.PI / 2;
			mesh.rotation.z = -Math.PI;
			mesh.changed = true;
			addChild(mesh);
			_planes[BACK] = mesh;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get planes():Vector.<Mesh> {
			return _planes;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		override public function toString():String {
			return "[nest.object.geom.SkyBox]";
		}
	}

}