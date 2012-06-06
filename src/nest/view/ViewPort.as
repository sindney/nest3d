package nest.view
{
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	import nest.view.lights.PointLight;
	import nest.view.lights.AmbientLight;
	import nest.view.lights.DirectionalLight;
	import nest.view.lights.SpotLight;
	import nest.view.lights.ILight;
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.IPlaceable;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.LODMesh;
	import nest.object.Sound3D;
	
	/** 
	 * Dispatched when context3D is created.
	 * @eventType flash.events.Event
	 */
	[Event(name = Event.CONTEXT3D_CREATE, type = "flash.events.Event")]
	
	/**
	 * ViewPort
	 */
	public class ViewPort extends EventDispatcher {
		
		private var stage3d:Stage3D;
		private var vertices:Vector.<Vector3D>;
		
		private var _context3D:Context3D;
		private var _draw:Matrix3D;
		private var _width:Number;
		private var _height:Number;
		private var _antiAlias:int = 0;
		
		private var _color:uint = 0x000000;
		private var _rgba:Vector.<Number> = new Vector.<Number>(4, true);
		private var _camPos:Vector.<Number> = new Vector.<Number>(4, true);
		private var _shaderParameters:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var _lights:Vector.<ILight>;
		private var _fog:Fog;
		
		private var _diagram:Diagram;
		private var _numVertices:int = 0;
		private var _numTriangles:int = 0;
		private var _numObjects:int = 0;
		
		private var _camera:Camera3D;
		private var _root:IContainer3D;
		
		public function ViewPort(width:Number, height:Number, stage3d:Stage3D, camera:Camera3D, root:IContainer3D) {
			this.stage3d = stage3d;
			
			_camera = camera;
			_root = root;
			
			vertices = new Vector.<Vector3D>(8, true);
			vertices[0] = new Vector3D();
			vertices[1] = new Vector3D();
			vertices[2] = new Vector3D();
			vertices[3] = new Vector3D();
			vertices[4] = new Vector3D();
			vertices[5] = new Vector3D();
			vertices[6] = new Vector3D();
			vertices[7] = new Vector3D();
			
			_draw = new Matrix3D();
			_lights = new Vector.<ILight>(10, true);
			
			_width = width;
			_height = height;
			
			_diagram = new Diagram();
			
			// setup scene
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, init);
			stage3d.requestContext3D();
		}
		
		/**
		 * Project a point from world space to screen space.
		 * <p>If the point is in front of the camera, then result.z = 0, otherwise, result.z = 1.</p>
		 */
		public function projectVector(p:Vector3D):Vector3D {
			const vx:Number = _width * 0.5;
			const vy:Number = _height * 0.5;
			var result:Vector3D = Utils3D.projectVector(camera.pm, camera.invertMatrix.transformVector(p));
			result.x = result.x * vx + vx;
			result.y = vy - result.y * vy;
			return result;
		}
		
		private function init(e:Event):void {
			_context3D = stage3d.context3D;
			_context3D.configureBackBuffer(_width, _height, _antiAlias, true);
			camera.aspect = _width / _height;
			dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
		}
		
		private function doMesh(mesh:IMesh):void {
			_numVertices += mesh.data.numVertices;
			_numTriangles += mesh.data.numTriangles;
			_numObjects += 1;
			_draw.copyFrom(mesh.matrix);
			_draw.append(camera.invertMatrix);
			_draw.append(camera.pm);
			mesh.draw(_context3D, _draw);
		}
		
		private function doContainer(container:IContainer3D, parent:IContainer3D = null, changed:Boolean = false):void {
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
					if (mesh.changed || mark) {
						mesh.recompose();
						mesh.matrix.append(container.matrix);
					}
					if (mesh.visible) {
						if (mesh is LODMesh) (mesh as LODMesh).update(camera.position);
						if (!mesh.cliping || classifyMesh(mesh)) doMesh(mesh);
					}
				} else if (object is Sound3D) {
					(object as Sound3D).update(camera.invertMatrix, container.matrix);
				}
			}
		}
		
		private function classifyMesh(mesh:IMesh):Boolean {
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
		
		/**
		 * Put this into a loop to draw your scene on stage3d.
		 */
		public function calculate(bitmapData:BitmapData = null, draw:Boolean = true):void {
			if (!camera || !root || !_context3D) return;
			
			_context3D.clear(_rgba[0], _rgba[1], _rgba[2], 1);
			
			_diagram.update();
			
			var light:ILight;
			var j:int = 1;
			for each(light in lights) {
				if (!light) continue;
				if (light is AmbientLight) {
					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, light.rgba);
				} else if (light is DirectionalLight) {
					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as DirectionalLight).direction);
					j += 2;
				} else if (light is PointLight) {
					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as PointLight).position);
					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 2, (light as PointLight).radius);
					j += 3;
				} else if (light is SpotLight) {
					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j, light.rgba);
 					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 1, (light as SpotLight).position);
					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 2, (light as SpotLight).direction);
					_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, j + 3, (light as SpotLight).lightParameters);
					j += 4;
				}
			}
			
			_shaderParameters[0] = 0;
			_shaderParameters[1] = 0;
			_shaderParameters[2] = 0;
			_shaderParameters[3] = 0.01;
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 22, _shaderParameters);
			
			_camPos[0] = camera.position.x;
			_camPos[1] = camera.position.y;
			_camPos[2] = camera.position.z;
			_camPos[3] = 1;
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 21, _camPos);
			
			if (fog) {
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 20, fog.color);
 				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 19, fog.data);
			}
			
			if (camera.changed) camera.recompose();
			
			_numVertices = 0;
			_numTriangles = 0;
			_numObjects = 0;
			
			doContainer(root);
			
			if (bitmapData) _context3D.drawToBitmapData(bitmapData);
			if (draw) _context3D.present();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * There's 19 empty fc left. 
		 * <p>Ambient light absorbs 1 fc.</p>
		 * <p>Directional light takes 2.</p>
		 * <p>PointLight light takes 3.</p>
		 * <p>SpotLight light takes 4.</p>
		 */
		public function get lights():Vector.<ILight> {
			return _lights;
		}
		
		public function get width():Number {
			return _width;
		}
		
		public function set width(value:Number):void {
			if (_width != value) {
				if (_context3D) {
					_width = value;
					_context3D.configureBackBuffer(_width, _height, _antiAlias, true);
					camera.aspect = _width / _height;
				}
			}
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function set height(value:Number):void {
			if (_height != value) {
				if (_context3D) {
					_height = value;
					_context3D.configureBackBuffer(_width, _height, _antiAlias, true);
					camera.aspect = _width / _height;
				}
			}
		}
		
		public function get color():uint {
			return _color;
		}
		
		/**
		 * Set Background color.
		 */
		public function set color(value:uint):void {
			_color = value;
			_rgba[0] = ((value >> 16) & 0xFF) / 255;
			_rgba[1] = ((value >> 8) & 0xFF) / 255;
			_rgba[2] = (value & 0xFF) / 255;
			_rgba[3] = 1;
		}
		
		public function get antiAlias():int {
			return _antiAlias;
		}
		
		public function set antiAlias(value:int):void {
			if (_antiAlias != value) {
				_antiAlias = value;
				if (_context3D) _context3D.configureBackBuffer(_width, _height, _antiAlias, true);
			}
		}
		
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
		
		public function get diagram():Diagram {
			return _diagram;
		}
		
		public function get fog():Fog {
			return _fog;
		}
		
		public function set fog(value:Fog):void {
			_fog = value;
		}
		
		public function get context3D():Context3D {
			return _context3D;
		}
		
		public function get camera():Camera3D {
			return _camera;
		}
		
		public function get root():IContainer3D {
			return _root;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		override public function toString():String {
			return "[nest.view.ViewPort]";
		}
		
	}

}