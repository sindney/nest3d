package nest.view.managers 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix3D;
	
	import nest.control.GlobalMethods;
	import nest.object.Graphics3D;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	import nest.object.LODMesh;
	import nest.object.Sound3D;
	import nest.view.culls.ICulling;
	import nest.view.materials.EnvMapMaterial;
	import nest.view.processes.IProcess;
	
	/**
	 * BasicManager
	 */
	public class BasicManager implements ISceneManager {
		
		protected var draw:Matrix3D;
		
		protected var _numVertices:int;
		protected var _numTriangles:int;
		protected var _numObjects:int;
		
		protected var _first:Boolean = true;
		protected var _culling:ICulling;
		protected var _process:IProcess;
		
		protected var _objects:Vector.<IMesh>;
		
		public function BasicManager() {
			draw = new Matrix3D();
		}
		
		public function calculate():void {
			if (_first) {
				_numVertices = 0;
				_numTriangles = 0;
				_numObjects = 0;
				_objects = new Vector.<IMesh>();
				doContainer(GlobalMethods.root, null, GlobalMethods.root.changed);
			} else {
				if (!_objects) return;
				var mesh:IMesh;
				for each(mesh in _objects) {
					if (!_culling) {
						_process ? _process.doMesh(mesh) : doMesh(mesh);
					} else if (_culling.classifyMesh(mesh)) {
						_process ? _process.doMesh(mesh) : doMesh(mesh);
					}
				}
			}
		}
		
		protected function doMesh(mesh:IMesh):void {
			var context3d:Context3D = GlobalMethods.context3d;
			
			draw.copyFrom(mesh.matrix);
			draw.append(GlobalMethods.camera.invertMatrix);
			draw.append(GlobalMethods.camera.pm);
			
			context3d.setCulling(mesh.culling);
			context3d.setBlendFactors(mesh.blendMode.source, mesh.blendMode.dest);
			context3d.setDepthTest(mesh.blendMode.depthMask, Context3DCompareMode.LESS);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, draw, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, mesh.invertMatrix, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 23, mesh.invertMatrix, true);
			
			if (mesh.material is EnvMapMaterial) context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 11, mesh.matrix, true);
			
			mesh.data.upload(context3d, mesh.material.uv, mesh.shader.normal);
			mesh.material.upload(context3d);
			if (mesh.shader.changed) {
				mesh.shader.changed = false;
				if (!mesh.shader.program) mesh.shader.program = context3d.createProgram();
				mesh.shader.program.upload(mesh.shader.vertex, mesh.shader.fragment);
			}
			
			context3d.setProgram(mesh.shader.program);
			context3d.drawTriangles(mesh.data.indexBuffer);
			
			mesh.data.unload(context3d);
			mesh.material.unload(context3d);
		}
		
		protected function doContainer(container:IContainer3D, parent:IContainer3D = null, changed:Boolean = false):void {
			if (_culling && !_culling.classifyContainer(container)) return;
			var mark:Boolean = changed;
			
			if (container.changed || parent && changed) {
				mark = true;
				container.recompose();
				if (parent) container.matrix.append(parent.matrix);
			}
			
			var mesh:IMesh;
			var object:IObject3D;
			var i:int, j:int = container.numChildren;
			for (i = 0; i < j; i++) {
				object = container.getChildAt(i);
				if (object.changed || mark) {
					object.recompose();
					object.matrix.append(container.matrix);
				}
				if (object is IContainer3D) {
					doContainer(object as IContainer3D, container, mark);
				} else if (object is IMesh) {
					mesh = object as IMesh;
					if (mesh.visible) {
						if (!mesh.cliping || _culling && _culling.classifyMesh(mesh)) {
							if (mesh is LODMesh) (mesh as LODMesh).update();
							_numVertices += mesh.data.numVertices;
							_numTriangles += mesh.data.numTriangles;
							_numObjects++;
							_process ? _process.doMesh(mesh) : doMesh(mesh);
							_objects.push(mesh);
						}
					}
				} else if (object is Sound3D) {
					(object as Sound3D).calculate();
				} else if (object is Graphics3D) {
					(object as Graphics3D).calculate();
				}
			}
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
		
		public function get objects():Vector.<IMesh> {
			return _objects;
		}
		
		public function get first():Boolean {
			return _first;
		}
		
		public function set first(value:Boolean):void {
			_first = value;
		}
		
		public function get culling():ICulling {
			return _culling;
		}
		
		public function set culling(value:ICulling):void {
			_culling = value;
		}
		
		public function get process():IProcess {
			return _process;
		}
		
		public function set process(value:IProcess):void {
			_process = value;
		}
		
	}

}