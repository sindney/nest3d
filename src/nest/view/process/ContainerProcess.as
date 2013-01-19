package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.partition.IPNode;
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * ContainerProcess
	 */
	public class ContainerProcess implements IContainerProcess {
		
		protected var _renderTarget:TextureProcess;
		
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
		
		public function ContainerProcess(camera:Camera3D, container:IContainer3D, color:uint = 0xff000000) {
			this.camera = camera;
			this.container = container;
			this.color = color;
			_renderTarget = new TextureProcess();
		}
		
		public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
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
			
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear(_rgba[0], _rgba[1], _rgba[2], _rgba[3]);
			
			_meshProcess.initialize();
			
			while (container) {
				if (!container.visible) {
					container = containers.pop();
					continue;
				}
				
				if (container.partition) {
					var nodes:Vector.<IPNode> = new Vector.<IPNode>();
					var node:IPNode = container.partition.root;
					while (node) {
						if (node.classify(_camera)) {
							j = node.childs.length;
							for (i = 0; i < j; i++) {
								if (node.childs[i]) {
									nodes.push(node.childs[i]);
								}
							}
							if (node.objects) {
								j = node.objects.length;
								for (i = 0; i < j; i++) {
									mesh = node.objects[i];
									if (mesh.visible) {
										_numVertices += mesh.geom.numVertices;
										_numTriangles += mesh.geom.numTriangles;
										_numObjects++;
										_meshProcess.calculate(mesh, ivm, pm);
										_objects.push(mesh);
										if (mesh.cliping)_excludedObjects.push(mesh);
									}
								}
							}
						}
						node = nodes.pop();
					}
				} else {
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
									_meshProcess.calculate(mesh, ivm, pm);
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
				}
				
				container = containers.pop();
			}
		}
		
		protected function classifyMesh(mesh:IMesh):Boolean {
			var i:int;
			if (mesh.bound is AABB) {
				var vertices:Vector.<Vector3D> = new Vector.<Vector3D>(8, true);
				for (i = 0; i < 8; i++) {
					vertices[i] = _camera.invertMatrix.transformVector(
									mesh.worldMatrix.transformVector((mesh.bound as AABB).vertices[i])
								);
				}
				return _camera.frustum.classifyAABB(vertices);
			}
			
			// BoundingShpere
			i = mesh.scale.x > mesh.scale.y ? mesh.scale.x : mesh.scale.y;
			if (mesh.scale.z > i) i = mesh.scale.z;
			return _camera.frustum.classifyBSphere(
						_camera.invertMatrix.transformVector(mesh.worldMatrix.transformVector(mesh.bound.center)), 
						(mesh.bound as BSphere).radius * i
					);
		}
		
		public function dispose():void {
			_renderTarget = null;
			_container = null;
			_meshProcess = null;
			_objects = null;
			_excludedObjects = null;
			_camera = null;
			_rgba = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get renderTarget():TextureProcess {
			return _renderTarget;
		}
		
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
			_rgba[3] = ((value >> 24) & 0xFF) / 255;
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