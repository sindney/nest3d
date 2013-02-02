package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	import nest.object.IMesh;
	import nest.view.Camera3D;
	
	/**
	 * QuadNode
	 */
	public class QuadNode implements IPNode {
		
		protected var _childs:Vector.<IPNode>;
		protected var _objects:Vector.<IMesh>;
		
		protected var _parent:IPNode;
		
		protected var _vertices:Vector.<Vector3D>;
		
		protected var _depth:int;
		
		public function QuadNode() {
			_childs = new Vector.<IPNode>(4, true);
			_vertices = new Vector.<Vector3D>(4, true);
			for (var i:int = 0; i < 4; i++) {
				_vertices[i] = new Vector3D();
			}
		}
		
		public function classify(camera:Camera3D):Boolean {
			var i:int, j:int = _vertices.length;
			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>(j, true);
			for (i = 0; i < j; i++) {
				vertices[i] = camera.invertMatrix.transformVector(_vertices[i]);
			}
			return camera.frustum.classifyAABB(vertices);
		}
		
		public function dispose():void {
			var i:int, j:int = _childs.length;
			var node:IPNode;
			for (i = 0; i < j; i++) {
				node = _childs[i];
				if (node) node.dispose();
				_childs[i] = null;
			}
			_objects = null;
			_parent = null;
			_depth = 0;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get childs():Vector.<IPNode> {
			return _childs;
		}
		
		public function get objects():Vector.<IMesh> {
			return _objects;
		}
		
		public function set objects(value:Vector.<IMesh>):void {
			_objects = value;
		}
		
		public function get vertices():Vector.<Vector3D> {
			return _vertices;
		}
		
		public function get max():Vector3D {
			return _vertices[3];
		}
		
		public function get min():Vector3D {
			return _vertices[0];
		}
		
		public function get depth():int {
			return _depth;
		}
		
		public function set depth(value:int):void {
			_depth = value;
		}
		
		public function get parent():IPNode {
			return _parent;
		}
		
		public function set parent(value:IPNode):void {
			_parent = value;
		}
		
	}

}