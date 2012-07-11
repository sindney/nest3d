package nest.view.managers 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IPlaceable;
	import nest.object.LODMesh;
	import nest.object.Mesh;
	import nest.object.SkyBox;
	import nest.object.Sound3D;
	import nest.view.Camera3D;
	
	/**
	 * BasicManager
	 */
	public class BasicManager implements ISceneManager {
		
		protected var vertices:Vector.<Vector3D>;
		protected var draw:Matrix3D;
		
		protected var _numVertices:int;
		protected var _numTriangles:int;
		protected var _numObjects:int;
		
		protected var _camera:Camera3D;
		protected var _root:IContainer3D;
		protected var _context3D:Context3D;
		
		public function BasicManager() {
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
			draw = new Matrix3D();
		}
		
		public function calculate():void {
			_numVertices = 0;
			_numTriangles = 0;
			_numObjects = 0;
			doContainer(_root, null, _root.changed);
		}
		
		protected function doContainer(container:IContainer3D, parent:IContainer3D = null, changed:Boolean = false):void {
			if (!container.visible) return;
			var mark:Boolean = changed;
			
			if (container.changed || parent && changed) {
				mark = true;
				container.recompose();
				if (parent) container.matrix.append(parent.matrix);
			}
			
			var mesh:IMesh;
			var object:IPlaceable;
			var i:int, j:int = container.numChildren;
			for (i = 0; i < j; i++) {
				object = container.getChildAt(i);
				if (object is IContainer3D) {
					doContainer(object as IContainer3D, container, mark);
				} else if (object is IMesh) {
					mesh = object as IMesh;
					if (mesh is SkyBox) {
						mesh.position.copyFrom(_camera.position);
						mesh.changed = true;
					}
					if (mesh.changed || mark) {
						mesh.recompose();
						mesh.matrix.append(container.matrix);
					}
					if (mesh.visible) {
						if (!mesh.cliping || classifyMesh(mesh)) {
							if (mesh is LODMesh) (mesh as LODMesh).update(_camera.position);
							doMesh(mesh);
						}
					}
				} else if (object is Sound3D) {
					(object as Sound3D).update(_camera.invertMatrix, container.matrix);
				}
			}
		}
		
		protected function doMesh(mesh:IMesh):void {
			_numVertices += mesh.data.numVertices;
			_numTriangles += mesh.data.numTriangles;
			_numObjects++;
			draw.copyFrom(mesh.matrix);
			draw.append(_camera.invertMatrix);
			draw.append(_camera.pm);
			mesh.draw(_context3D, draw);
		}
		
		protected function classifyMesh(mesh:IMesh):Boolean {
			var i:int;
			var v:Vector3D = new Vector3D();
			if (mesh.bound is AABB) {
				for (i = 0; i < 8; i++) {
					v.copyFrom((mesh.bound as AABB).vertices[i]);
					v.copyFrom(_camera.invertMatrix.transformVector(mesh.matrix.transformVector(v)));
					vertices[i].copyFrom(v);
				}
				return _camera.frustum.classifyAABB(vertices);
			}
			
			// BoundingShpere
			i = mesh.scale.x > mesh.scale.y ? mesh.scale.x : mesh.scale.y;
			if (mesh.scale.z > i) i = mesh.scale.z;
			v.copyFrom(_camera.invertMatrix.transformVector(mesh.matrix.transformVector(mesh.bound.center)));
			return _camera.frustum.classifyBSphere(v, (mesh.bound as BSphere).radius * i);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Get the amount of vertices drawn during last rendering process.
		 */
		public function get numVertices():int {
			return _numVertices;
		}
		
		/**
		 * Get the amount of triangles drawn during last rendering process.
		 */
		public function get numTriangles():int {
			return _numTriangles;
		}
		
		/**
		 * Get the amount of objects drawn during last rendering process.
		 */
		public function get numObjects():int {
			return _numObjects;
		}
		
		public function get context3D():Context3D {
			return _context3D;
		}
		
		public function set context3D(value:Context3D):void {
			_context3D = value;
		}
		
		public function get root():IContainer3D {
			return _root;
		}
		
		public function set root(value:IContainer3D):void {
			_root = value;
		}
		
		public function get camera():Camera3D {
			return _camera;
		}
		
		public function set camera(value:Camera3D):void {
			_camera = value;
		}
		
	}

}