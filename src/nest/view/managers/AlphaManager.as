package nest.view.managers 
{
	import nest.control.EngineBase;
	import nest.object.IMesh;
	import nest.view.Camera3D;
	
	/**
	 * AlphaManager
	 */
	public class AlphaManager extends BasicManager {
		
		protected var _alphaObjects:Vector.<IMesh>;
		protected var distance:Vector.<Number>;
		
		public function AlphaManager() {
			super();
		}
		
		override public function calculate():void {
			var i:int, j:int;
			var mesh:IMesh;
			
			if (_first) {
				_numVertices = 0;
				_numTriangles = 0;
				_numObjects = 0;
				
				_objects = new Vector.<IMesh>();
				_alphaObjects = new Vector.<IMesh>();
				distance = new Vector.<Number>();
				doContainer(EngineBase.root, null);
				
				j = distance.length - 1;
				if (j > 1) quickSort(distance, 0, j);
				
				for (i = j; i > 0; i--) {
					mesh = _alphaObjects[i];
					_process ? _process.doMesh(mesh) : super.doMesh(mesh);
				}
			} else {
				if (!_objects) return;
				for each(mesh in _objects) {
					if (!mesh.alphaTest) {
						if (!_culling) {
							_process ? _process.doMesh(mesh) : super.doMesh(mesh);
						} else if (_culling.classifyMesh(mesh)) {
							_process ? _process.doMesh(mesh) : super.doMesh(mesh);
						}
					}
				}
				
				j = distance.length - 1;
				for (i = j; i > 0; i--) {
					mesh = _alphaObjects[i];
					if (!_culling) {
						_process ? _process.doMesh(mesh) : super.doMesh(mesh);
					} else if (_culling.classifyMesh(mesh)) {
						_process ? _process.doMesh(mesh) : super.doMesh(mesh);
					}
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
				_alphaObjects.push(mesh);
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
					obj = _alphaObjects[i];
					_alphaObjects[i] = _alphaObjects[j];
					_alphaObjects[j] = obj;
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
		
		public function get alphaObjects():Vector.<IMesh> {
			return _alphaObjects;
		}
		
	}

}