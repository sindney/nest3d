package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	import nest.view.Camera3D;
	
	/**
	 * ContainerProcess
	 */
	public class ContainerProcess extends RenderProcess implements IContainerProcess {
		
		protected var _meshProcess:IMeshProcess;
		protected var _container:IContainer3D;
		
		protected var _objects:Vector.<IMesh>;
		protected var _excludedObjects:Vector.<IMesh>;
		
		protected var _camera:Camera3D;
		
		protected var _color:uint;
		protected var _rgba:Vector.<Number> = new Vector.<Number>(4, true);
		
		protected var _numVertices:int = 0;
		protected var _numTriangles:int = 0;
		protected var _numObjects:int = 0;
		
		protected var vertices:Vector.<Vector3D>;
		
		public function ContainerProcess(camera:Camera3D, container:IContainer3D, color:uint = 0xff000000) {
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
			this.camera = camera;
			this.container = container;
			this.color = color;
		}
		
		override public function calculate(context3d:Context3D, next:IRenderProcess):void {
			var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
			var container:IContainer3D = _container;
			var object:IObject3D;
			var mesh:IMesh;
			
			var ivm:Matrix3D = this.ivm;
			var pm:Matrix3D = this.pm;
			
			var i:int, j:int;
			
			_objects = new Vector.<IMesh>();
			_excludedObjects = new Vector.<IMesh>();
			
			_numVertices = 0;
			_numTriangles = 0;
			_numObjects = 0;
			
			if (_texture != null) {
				context3d.setRenderToTexture(_texture, _enableDepthAndStencil, _antiAlias);
			} else if (next != null && next is IEffectProcess) {
				var effectProcess:IEffectProcess = next as IEffectProcess;
				context3d.setRenderToTexture(effectProcess.texture, 
											effectProcess.enableDepthAndStencil, 
											effectProcess.antiAlias);
			} else {
				context3d.setRenderToBackBuffer();
			}
			if (_clear) context3d.clear(_rgba[0], _rgba[1], _rgba[2], _rgba[3]);
			
			_meshProcess.initialize(context3d);
			
			while (container) {
				if (!container.visible) {
					container = containers.pop();
					continue;
				}
				
				j = container.numChildren;
				for (i = 0; i < j; i++) {
					object = container.getChildAt(i);
					if (object is IMesh) {
						mesh = object as IMesh;
						if (mesh.visible) {
							if (!mesh.cliping || classifyMesh(mesh)) {
								_numVertices += mesh.geom.numVertices;
								_numTriangles += mesh.geom.numTriangles;
								_numObjects++;
								_meshProcess.calculate(context3d, mesh, ivm, pm);
								_objects.push(mesh);
								if (mesh.cliping)_excludedObjects.push(mesh);
							} else {
								_excludedObjects.push(mesh);
							}
						}
					} else if (object is IContainer3D) {
						containers.push(object as IContainer3D);
					}
				}
				
				container = containers.pop();
			}
		}
		
		protected function classifyMesh(mesh:IMesh):Boolean {
			var i:int;
			var v:Vector3D = new Vector3D();
			if (mesh.bound is AABB) {
				for (i = 0; i < 8; i++) {
					v.copyFrom((mesh.bound as AABB).vertices[i]);
					v.copyFrom(_camera.invertMatrix.transformVector(mesh.worldMatrix.transformVector(v)));
					vertices[i].copyFrom(v);
				}
				return _camera.frustum.classifyAABB(vertices);
			}
			
			// BoundingShpere
			i = mesh.scale.x > mesh.scale.y ? mesh.scale.x : mesh.scale.y;
			if (mesh.scale.z > i) i = mesh.scale.z;
			v.copyFrom(_camera.invertMatrix.transformVector(mesh.worldMatrix.transformVector(mesh.bound.center)));
			return _camera.frustum.classifyBSphere(v, (mesh.bound as BSphere).radius * i);
		}
		
		override public function dispose():void {
			super.dispose();
			_container = null;
			_meshProcess = null;
			_objects = null;
			_excludedObjects = null;
			_camera = null;
			_rgba = null;
			vertices = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get container():IContainer3D {
			return _container;
		}
		
		public function set container(value:IContainer3D):void {
			_container = value;
		}
		
		public function get meshProcess():IMeshProcess {
			return _meshProcess;
		}
		
		public function set meshProcess(value:IMeshProcess):void {
			_meshProcess = value;
		}
		
		public function get objects():Vector.<IMesh> {
			return _objects;
		}
		
		public function get excludedObjects():Vector.<IMesh> {
			return _excludedObjects;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
			_rgba[0] = ((value >> 16) & 0xFF) / 255;
			_rgba[1] = ((value >> 8) & 0xFF) / 255;
			_rgba[2] = (value & 0xFF) / 255;
			_rgba[3] = (value >> 24) / 255;
		}
		
		public function get numVertices():int {
			return _numVertices;
		}
		
		public function get numTriangles():int {
			return _numTriangles;
		}
		
		public function get numObjects():int {
			return _numObjects;
		}
		
		public function get camera():Camera3D {
			return _camera;
		}
		
		public function set camera(value:Camera3D):void {
			_camera = value;
		}
		
		public function get ivm():Matrix3D {
			return _camera.invertMatrix;
		}
		
		public function get pm():Matrix3D {
			return _camera.pm;
		}
		
	}

}