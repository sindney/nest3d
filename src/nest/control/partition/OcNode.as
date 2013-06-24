package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	import nest.control.event.MatrixEvent;
	import nest.object.IMesh;
	
	/**
	 * OcNode
	 */
	public class OcNode {
		
		protected var _max:Vector3D = new Vector3D();
		protected var _min:Vector3D = new Vector3D();
		
		public var childs:Vector.<OcNode>;
		public var objects:Vector.<IMesh> = new Vector.<IMesh>(0);
		public var parent:OcNode;
		public var depth:int;
		
		public function dispose(tree:OcTree):void {
			var i:int, j:int;
			if (childs) {
				var node:OcNode;
				for (i = 0; i < 8; i++) {
					node = childs[i];
					node.dispose(tree);
				}
				childs = null;
			}
			if (objects) {
				j = objects.length;
				var mesh:IMesh;
				for (i = 0; i < j; i++) {
					mesh = objects[i];
					mesh.removeEventListener(MatrixEvent.TRANSFORM_CHANGE, tree.onTransformChange);
					mesh.node = null;
				}
				objects = null;
			}
			parent = null;
			depth = 0;
			_max.setTo(0, 0, 0);
			_min.setTo(0, 0, 0);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get max():Vector3D {
			return _max;
		}
		
		public function get min():Vector3D {
			return _min;
		}
		
	}

}