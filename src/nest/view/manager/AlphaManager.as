package nest.view.manager 
{
	import nest.control.EngineBase;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	import nest.view.Camera3D;
	
	/**
	 * AlphaManager
	 */
	public class AlphaManager extends BasicManager {
		
		protected var _sortObjects:Vector.<IMesh>;
		protected var distance:Vector.<Number>;
		
		public function AlphaManager() {
			super();
		}
		
		override public function calculate():void {
			var mesh:IMesh;
			var i:int, j:int;
			if (_first) {
				_numVertices = 0;
				_numTriangles = 0;
				_numObjects = 0;
				
				_objects = new Vector.<IMesh>();
				_sortObjects = new Vector.<IMesh>();
				distance = new Vector.<Number>();
				
				var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
				var container:IContainer3D = EngineBase.root;
				var object:IObject3D;
				var partition:Boolean;
				
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
									if (mesh.alphaTest) {
										_sortObjects.push(mesh);
									} else {
										_numVertices += mesh.data.numVertices;
										_numTriangles += mesh.data.numTriangles;
										_numObjects++;
										_process ? _process.doMesh(mesh) : doMesh(mesh);
										_objects.push(mesh);
									}
								}
							}
						}
					}
					
					container = containers.pop();
				}
				
				j = distance.length - 1;
				if (j > 1) quickSort(distance, 0, j);
				
				for (i = j; i > 0; i--) {
					mesh = _sortObjects[i];
					_numVertices += mesh.data.numVertices;
					_numTriangles += mesh.data.numTriangles;
					_numObjects++;
					_process ? _process.doMesh(mesh) : super.doMesh(mesh);
				}
			} else {
				j = _objects.length;
				for (i = 0; i < j; i++) {
					mesh = _objects[i];
					_process ? _process.doMesh(mesh) : super.doMesh(mesh);
				}
				
				j = distance.length - 1;
				for (i = j; i > 0; i--) {
					mesh = _sortObjects[i];
					_process ? _process.doMesh(mesh) : super.doMesh(mesh);
				}
			}
		}
		
		override protected function doMesh(mesh:IMesh):void {
			if (mesh.alphaTest) {
				var camera:Camera3D = EngineBase.camera;
				var dx:Number = mesh.position.x - camera.position.x;
				var dy:Number = mesh.position.y - camera.position.y;
				var dz:Number = mesh.position.z - camera.position.z;
				distance.push(dx * dx + dy * dy + dz * dz);
				_sortObjects.push(mesh);
			} else {
				_process ? _process.doMesh(mesh) : super.doMesh(mesh);
			}
		}
		
		protected function quickSort(source:Vector.<Number>, left:int, right:int):void {
			var i:int = left;
			var j:int = right;
			var key:Number = source[(left + right) >> 1];
			var temp:Number;
			var obj:IMesh;
			// loop
			while (i <= j) {
				while (source[i] < key) i++;
				while (source[j] > key) j--;
				if (i <= j) {
					temp = source[i];
					source[i] = source[j];
					source[j] = temp;
					obj = _sortObjects[i];
					_sortObjects[i] = _sortObjects[j];
					_sortObjects[j] = obj;
					i++;
					j--;
				}
			}
			// swap
			if (left < j) quickSort(source, left, j);
			if (i < right) quickSort(source, i, right);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get sortObjects():Vector.<IMesh> {
			return _sortObjects;
		}
		
	}

}