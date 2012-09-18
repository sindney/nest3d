package nest.view.manager 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.EngineBase;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	import nest.object.LODMesh;
	import nest.object.Sprite3D;
	import nest.object.IUpdateable;
	import nest.view.cull.ICulling;
	import nest.view.material.EnvMapMaterial;
	import nest.view.process.IProcess;
	
	/**
	 * BasicManager
	 */
	public class BasicManager implements ISceneManager {
		
		protected var draw:Matrix3D;
		protected var matrix:Matrix3D;
		protected var invertMatrix:Matrix3D;
		
		protected var _numVertices:int;
		protected var _numTriangles:int;
		protected var _numObjects:int;
		
		protected var _first:Boolean = true;
		protected var _culling:ICulling;
		protected var _process:IProcess;
		
		protected var _objects:Vector.<IMesh>;
		
		public function BasicManager() {
			draw = new Matrix3D();
			matrix = new Matrix3D();
			invertMatrix = new Matrix3D();
		}
		
		public function calculate():void {
			var mesh:IMesh;
			if (_first) {
				_numVertices = 0;
				_numTriangles = 0;
				_numObjects = 0;
				_objects = new Vector.<IMesh>();
				
				var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
				var container:IContainer3D = EngineBase.root;
				var object:IObject3D;
				var partition:Boolean;
				var i:int, j:int;
				
				while (container) {
					if (_culling && !_culling.classifyContainer(container)) {
						container = containers.pop();
						continue;
					}
					
					partition = container.partition != null;
					if (partition) {
						// TODO:记得push mesh到_objects
					}
					
					j = container.numChildren;
					for (i = 0; i < j; i++) {
						object = container.getChildAt(i);
						if (object is IUpdateable) (object as IUpdateable).update();
						if (!partition) {
							if (object is IContainer3D) {
								containers.push(object);
							} else if (object is IMesh) {
								mesh = object as IMesh;
								if (mesh.visible && (!mesh.cliping || _culling && _culling.classifyMesh(mesh))) {
									_numVertices += mesh.data.numVertices;
									_numTriangles += mesh.data.numTriangles;
									_numObjects++;
									_process ? _process.doMesh(mesh) : doMesh(mesh);
									_objects.push(mesh);
								}
							}
						}
					}
					
					container = containers.pop();
				}
			} else {
				for each(mesh in _objects) {
					_process ? _process.doMesh(mesh) : doMesh(mesh);
				}
			}
		}
		
		protected function doMesh(mesh:IMesh):void {
			var context3d:Context3D = EngineBase.context3d;
			var comps:Vector.<Vector3D>;
			
			draw.copyFrom(mesh.worldMatrix);
			draw.append(EngineBase.camera.invertMatrix);
			if (mesh is Sprite3D) {
				comps = draw.decompose();
				comps[1].setTo(0, 0, 0);
				draw.recompose(comps);
			}
			draw.append(EngineBase.camera.pm);
			
			invertMatrix.copyFrom(mesh.invertWorldMatrix);
			invertMatrix.appendScale(mesh.scale.x, mesh.scale.y, mesh.scale.z);
			
			context3d.setCulling(mesh.culling);
			context3d.setBlendFactors(mesh.blendMode.source, mesh.blendMode.dest);
			context3d.setDepthTest(mesh.blendMode.depthMask, Context3DCompareMode.LESS);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, draw, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, invertMatrix, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 24, invertMatrix, true);
			
			if (mesh.material is EnvMapMaterial) {
				matrix.copyFrom(mesh.worldMatrix);
				comps = matrix.decompose();
				comps[0].setTo(0, 0, 0);
				comps[2].setTo(1, 1, 1);
				matrix.recompose(comps);
				context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 10, matrix, true);
			}
			
			mesh.data.upload(context3d, mesh.material.uv, mesh.material.shader.normal);
			mesh.material.upload(context3d);
			
			context3d.setProgram(mesh.material.shader.program);
			context3d.drawTriangles(mesh.data.indexBuffer);
			
			mesh.data.unload(context3d);
			mesh.material.unload(context3d);
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
		
		/**
		 * Indicates whether it's the first render process or not.
		 * <p>Usually use this to render visible objects all over again.</p>
		 */
		public function set first(value:Boolean):void {
			_first = value;
		}
		
		public function get culling():ICulling {
			return _culling;
		}
		
		/**
		 * Classify meshes by specific culling process.
		 */
		public function set culling(value:ICulling):void {
			_culling = value;
		}
		
		public function get process():IProcess {
			return _process;
		}
		
		/**
		 * Saves the process you want to use for rendering meshes.
		 * <p>Leave null to use the default rendering process.</p>
		 */
		public function set process(value:IProcess):void {
			_process = value;
		}
		
	}

}