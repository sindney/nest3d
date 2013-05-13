package nest.control.partition 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.event.MatrixEvent;
	import nest.object.IMesh;
	import nest.view.Camera3D;
	
	/**
	 * OcNode
	 */
	public class OcNode {
		
		protected var _bound:Vector.<Vector3D>;
		
		public var childs:Vector.<OcNode>;
		public var objects:Vector.<IMesh>;
		public var parent:OcNode;
		public var depth:int;
		
		public function OcNode() {
			var i:int;
			_bound = new Vector.<Vector3D>(8, true);
			for (i = 0; i < 8; i++) _bound[i] = new Vector3D();
			objects = new Vector.<IMesh>();
		}
		
		public function classify(camera:Camera3D, ivm:Matrix3D):Boolean {
			var i:int, j:int = _bound.length;
			var bound:Vector.<Vector3D> = new Vector.<Vector3D>(8, true);
			for (i = 0; i < 8; i++) {
				bound[i] = ivm.transformVector(_bound[i]);
			}
			return camera.frustum.classifyAABB(bound);
		}
		
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
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get bound():Vector.<Vector3D> {
			return _bound;
		}
		
	}

}