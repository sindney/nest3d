package nest.view.managers 
{
	import nest.object.IMesh;
	
	/**
	 * AlphaManager
	 */
	public class AlphaManager extends BasicManager {
		
		protected var objects:Vector.<IMesh>;
		protected var distance:Vector.<Number>;
		
		public function AlphaManager() {
			super();
		}
		
		override public function calculate():void {
			_numVertices = 0;
			_numTriangles = 0;
			_numObjects = 0;
			objects = new Vector.<IMesh>();
			distance = new Vector.<Number>();
			doContainer(_root, null, _root.changed);
			
			// sort objects
			var i:int, j:int = distance.length - 1;
			quickSort(distance, 0, j);
			
			// draw meshes
			var mesh:IMesh;
			for (i = j; i > 0; i--) {
				mesh = objects[i];
				draw.copyFrom(mesh.matrix);
				draw.append(_camera.invertMatrix);
				draw.append(_camera.pm);
				mesh.draw(_context3D, draw);
			}
		}
		
		override protected function doMesh(mesh:IMesh):void {
			_numVertices += mesh.data.numVertices;
			_numTriangles += mesh.data.numTriangles;
			_numObjects++;
			if (mesh.alphaTest) {
				var dx:Number = mesh.position.x - _camera.position.x;
				var dy:Number = mesh.position.y - _camera.position.y;
				var dz:Number = mesh.position.z - _camera.position.z;
				distance.push(dx * dx + dy * dy + dz * dz);
				objects.push(mesh);
			} else {
				draw.copyFrom(mesh.matrix);
				draw.append(_camera.invertMatrix);
				draw.append(_camera.pm);
				mesh.draw(_context3D, draw);
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
					obj = objects[i];
					objects[i] = objects[j];
					objects[j] = obj;
					i++;
					j--;
				}
			}
			// swap
			if (left < j) quickSort(source, left, j);
			if (i < right) quickSort(source, i, right);
		}
		
	}

}