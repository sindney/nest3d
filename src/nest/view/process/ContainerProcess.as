package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.partition.IPNode;
	import nest.object.geom.Geometry;
	import nest.object.geom.Bound;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	import nest.view.shader.*;
	import nest.view.Camera3D;
	import nest.view.TextureResource;
	import nest.view.ViewPort;
	
	/**
	 * ContainerProcess
	 */
	public class ContainerProcess implements IContainerProcess {
		
		protected var _renderTarget:RenderTarget;
		
		protected var _container:IContainer3D;
		
		protected var _objects:Vector.<IMesh>;
		protected var _alphaObjects:Vector.<IMesh>;
		
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
			_renderTarget = new RenderTarget();
		}
		
		public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
			var container:IContainer3D = _container;
			var object:IObject3D;
			var mesh:IMesh;
			var geom:Geometry;
			
			var i:int, j:int;
			var dx:int, dy:int, dz:int;
			
			var alphaParms:Vector.<int> = new Vector.<int>();
			
			var pm0:Matrix3D = camera.invertMatrix.clone();
			pm0.append(camera.pm);
			
			var pm1:Matrix3D = camera.invertMatrix.clone();
			var components:Vector.<Vector3D> = pm1.decompose();
			components[0].setTo(0, 0, 0);
			pm1.recompose(components);
			pm1.append(camera.pm);
			
			var pm2:Matrix3D = camera.invertMatrix.clone();
			components = pm2.decompose();
			components[1].setTo(0, 0, 0);
			pm2.recompose(components);
			pm2.append(camera.pm);
			
			var pm3:Matrix3D = camera.pm;
			
			_objects = new Vector.<IMesh>();
			_alphaObjects = new Vector.<IMesh>();
			
			_numVertices = 0;
			_numTriangles = 0;
			_numObjects = 0;
			
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias, _renderTarget.surfaceSelector);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear(_rgba[0], _rgba[1], _rgba[2], _rgba[3]);
			
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
										if (mesh.alphaTest) {
											dx = _camera.position.x - mesh.position.x;
											dy = _camera.position.y - mesh.position.y;
											dz = _camera.position.z - mesh.position.z;
											alphaParms.push(dx * dx + dy * dy + dz * dz);
											_alphaObjects.push(mesh);
										} else {
											drawMesh(mesh, mesh.ignorePosition ? (mesh.ignoreRotation ? pm3 : pm1) : (mesh.ignoreRotation ? pm2 : pm0));
											_objects.push(mesh);
										}
										for each(geom in mesh.geometries) {
											_numVertices += geom.numVertices;
											_numTriangles += geom.numTriangles;
										}
										_numObjects++;
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
									if (mesh.alphaTest) {
										dx = _camera.position.x - mesh.position.x;
										dy = _camera.position.y - mesh.position.y;
										dz = _camera.position.z - mesh.position.z;
										alphaParms.push(dx * dx + dy * dy + dz * dz);
										_alphaObjects.push(mesh);
									} else {
										drawMesh(mesh, mesh.ignorePosition ? (mesh.ignoreRotation ? pm3 : pm1) : (mesh.ignoreRotation ? pm2 : pm0));
										_objects.push(mesh);
									}
									for each(geom in mesh.geometries) {
										_numVertices += geom.numVertices;
										_numTriangles += geom.numTriangles;
									}
									_numObjects++;
								}
							}
						} else if (object is IContainer3D) {
							containers.push(object as IContainer3D);
						}
					}
				}
				
				container = containers.pop();
			}
			
			context3d.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			i = _alphaObjects.length - 1;
			if (i > 0) quickSort(alphaParms, 0, i);
			
			for each(mesh in _alphaObjects) drawMesh(mesh, mesh.ignorePosition ? (mesh.ignoreRotation ? pm3 : pm1) : (mesh.ignoreRotation ? pm2 : pm0));
			
			context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
		}
		
		public function drawMesh(mesh:IMesh, pm:Matrix3D):void {
			var context3d:Context3D = ViewPort.context3d;
			
			context3d.setCulling(mesh.triangleCulling);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mesh.matrix, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, mesh.worldMatrix, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, pm, true);
			
			var i:int, j:int = mesh.geometries.length;
			var uv:Boolean, normal:Boolean;
			var byteArraySP:ByteArrayShaderPart;
			var matrixSP:MatrixShaderPart;
			var vectorSP:VectorShaderPart;
			var geom:Geometry;
			var material:Vector.<TextureResource>;
			var shader:Shader3D;
			
			for (i = 0; i < j; i++) {
				geom = mesh.geometries[i];
				material = mesh.materials[i];
				shader = mesh.shaders[i];
				
				for each(var csp:IConstantShaderPart in shader.constantParts) {
					if (csp is ByteArrayShaderPart) {
						byteArraySP = csp as ByteArrayShaderPart;
						context3d.setProgramConstantsFromByteArray(byteArraySP.programType, byteArraySP.firstRegister, 
																	byteArraySP.numRegisters, byteArraySP.data, 
																	byteArraySP.byteArrayOffset);
					} else if (csp is MatrixShaderPart) {
						matrixSP = csp as MatrixShaderPart;
						context3d.setProgramConstantsFromMatrix(matrixSP.programType, matrixSP.firstRegister, 
																matrixSP.matrix, matrixSP.transposedMatrix);
					} else if (csp is VectorShaderPart) {
						vectorSP = csp as VectorShaderPart;
						context3d.setProgramConstantsFromVector(vectorSP.programType, vectorSP.firstRegister, 
																vectorSP.data, vectorSP.numRegisters);
					}
				}
				
				for each(var tr:TextureResource in material) context3d.setTextureAt(tr.sampler, tr.texture);
				
				normal = geom.normalBuffer != null;
				uv = geom.uvBuffer != null;
				
				context3d.setVertexBufferAt(0, geom.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				if (normal) context3d.setVertexBufferAt(1, geom.normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				if (uv) context3d.setVertexBufferAt(2, geom.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				
				context3d.setProgram(shader.program);
				
				context3d.drawTriangles(geom.indexBuffer);
				
				for each(tr in material) context3d.setTextureAt(tr.sampler, null);
				
				context3d.setVertexBufferAt(0, null);
				if (normal) context3d.setVertexBufferAt(1, null);
				if (uv) context3d.setVertexBufferAt(2, null);
			}
		}
		
		protected function classifyMesh(mesh:IMesh):Boolean {
			var i:int;
			if (mesh.bound.aabb) {
				var vertices:Vector.<Vector3D> = new Vector.<Vector3D>(8, true);
				for (i = 0; i < 8; i++) {
					vertices[i] = _camera.invertMatrix.transformVector(
									mesh.worldMatrix.transformVector(mesh.matrix.transformVector(mesh.bound.vertices[i]))
								);
				}
				return _camera.frustum.classifyAABB(vertices);
			}
			
			var id:Vector3D = mesh.worldMatrix.transformVector(mesh.matrix.transformVector(new Vector3D(0.577, 0.577, 0.577)));
			var scale:Number = id.length;
			return _camera.frustum.classifyBSphere(
						_camera.invertMatrix.transformVector(mesh.worldMatrix.transformVector(mesh.matrix.transformVector(mesh.bound.center))), 
						mesh.bound.radius * scale
					);
		}
		
		protected function quickSort(data:Vector.<int>, left:int, right:int):void {
			var i:int = left;
			var j:int = right;
			var key:int = data[(left + right) >> 1];
			var temp:int;
			var mesh:IMesh;
			// loop
			while (i <= j) {
				while (data[i] > key) i++;
				while (data[j] < key) j--;
				if (i <= j) {
					temp = data[i];
					data[i] = data[j];
					data[j] = temp;
					mesh = _alphaObjects[i];
					_alphaObjects[i] = _alphaObjects[j];
					_alphaObjects[j] = mesh;
					i++;
					j--;
				}
			}
			// swap
			if (left < j) quickSort(data, left, j);
			if (i < right) quickSort(data, i, right);
		}
		
		public function dispose():void {
			_renderTarget = null;
			_container = null;
			_objects = null;
			_alphaObjects = null;
			_camera = null;
			_rgba = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get renderTarget():RenderTarget {
			return _renderTarget;
		}
		
		public function get container():IContainer3D {
			return _container;
		}
		
		public function set container(value:IContainer3D):void {
			_container = value;
		}
		
		public function get objects():Vector.<IMesh> {
			return _objects;
		}
		
		public function get alphaObjects():Vector.<IMesh> {
			return _alphaObjects;
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
		
	}

}