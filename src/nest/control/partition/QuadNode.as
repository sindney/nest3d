package nest.view.partition 
{
	import flash.geom.Vector3D;
	
	import nest.control.EngineBase;
	import nest.object.IMesh;
	
	/**
	 * QuadNode
	 */
	public class QuadNode implements IPNode {
		
		private var _childs:Vector.<IPNode>;
		private var _objects:Vector.<IMesh>;
		
		private var _parent:IPNode;
		
		private var _max:Vector3D;
		private var _min:Vector3D;
		
		private var _depth:int;
		
		public function QuadNode() {
			_childs = new Vector.<IPNode>(4, true);
			_max = new Vector3D();
			_min = new Vector3D();
		}
		
		public function dispose():void {
			var i:int;
			var node:IPNode;
			for (i = 0; i < 4; i++) {
				node = _childs[i];
				if (node) {
					node.dispose();
					EngineBase.returnObject(node);
				}
				_childs[i] = null;
			}
			_objects = null;
			_parent = null;
			_max.setTo(0, 0, 0);
			_min.setTo(0, 0, 0);
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
		
		public function get max():Vector3D {
			return _max;
		}
		
		public function get min():Vector3D {
			return _min;
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