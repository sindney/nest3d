package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	import nest.control.event.MatrixEvent;
	import nest.control.util.CollisionTest;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	
	/**
	 * OcTree
	 */
	public class OcTree {
		
		protected var _root:OcNode;
		
		protected var target:IContainer3D;
		protected var size:Number;
		protected var maxDepth:int;
		
		public var frustum:Boolean = false;
		
		public function OcTree() {
			_root = new OcNode();
		}
		
		public function addChild(mesh:IMesh):void {
			if (!target) return;
			var node:OcNode = _root.depth < maxDepth ? findNode(mesh, _root) : _root;
			if (node) {
				mesh.node = node;
				mesh.addEventListener(MatrixEvent.TRANSFORM_CHANGE, onTransformChange);
				node.objects.push(mesh);
			}
		}
		
		public function removeChild(mesh:IMesh):void {
			if (!target) return;
			if (mesh.node) {
				mesh.node.objects.splice(mesh.node.objects.indexOf(mesh), 1);
				mesh.node = null;
				mesh.removeEventListener(MatrixEvent.TRANSFORM_CHANGE, onTransformChange);
			}
		}
		
		public function onTransformChange(e:MatrixEvent):void {
			var mesh:IMesh = e.target as IMesh;
			mesh.node.objects.splice(mesh.node.objects.indexOf(mesh), 1);
			mesh.node = null;
			var node:OcNode = _root.depth < maxDepth ? findNode(mesh, _root) : _root;
			if (node) {
				mesh.node = node;
				mesh.addEventListener(MatrixEvent.TRANSFORM_CHANGE, onTransformChange);
				node.objects.push(mesh);
			}
		}
		
		public function findNode(mesh:IMesh, node:OcNode):OcNode {
			var a:Vector3D = mesh.max;
			var b:Vector3D = mesh.min;
			var TTL:OcNode = node.childs[0];
			var TTR:OcNode = node.childs[1];
			var TBL:OcNode = node.childs[2];
			var TBR:OcNode = node.childs[3];
			var BTL:OcNode = node.childs[4];
			var BTR:OcNode = node.childs[5];
			var BBL:OcNode = node.childs[6];
			var BBR:OcNode = node.childs[7];
			var	BBTL:Boolean = CollisionTest.AABB_AABB(a, b, BTL.max, BTL.min);
			var	BBTR:Boolean = CollisionTest.AABB_AABB(a, b, BTR.max, BTR.min);
			var	BBBL:Boolean = CollisionTest.AABB_AABB(a, b, BBL.max, BBL.min);
			var	BBBR:Boolean = CollisionTest.AABB_AABB(a, b, BBR.max, BBR.min);
			var	BTTL:Boolean = CollisionTest.AABB_AABB(a, b, TTL.max, TTL.min);
			var	BTTR:Boolean = CollisionTest.AABB_AABB(a, b, TTR.max, TTR.min);
			var	BTBL:Boolean = CollisionTest.AABB_AABB(a, b, TBL.max, TBL.min);
			var	BTBR:Boolean = CollisionTest.AABB_AABB(a, b, TBR.max, TBR.min);
			if (BBTL && (BBTR || BBBL || BBBR || BTTL || BTTR || BTBL || BTBR) || 
				BBTR && (BBTL || BBBL || BBBR || BTTL || BTTR || BTBL || BTBR) || 
				BBBL && (BBTL || BBTR || BBBR || BTTL || BTTR || BTBL || BTBR) || 
				BBBR && (BBTL || BBTR || BBBL || BTTL || BTTR || BTBL || BTBR) || 
				BTTL && (BTTR || BTBL || BTBR || BBTL || BBTR || BBBL || BBBR) || 
				BTTR && (BTTL || BTBL || BTBR || BBTL || BBTR || BBBL || BBBR) || 
				BTBL && (BTTL || BTTR || BTBR || BBTL || BBTR || BBBL || BBBR) || 
				BTBR && (BTTL || BTTR || BTBL || BBTL || BBTR || BBBL || BBBR)) {
				return node;
			} else if (BBTL) {
				return BTL.depth + 1 < maxDepth ? findNode(mesh, BTL) : BTL;
			} else if (BBTR) {
				return BTR.depth + 1 < maxDepth ? findNode(mesh, BTR) : BTR;
			} else if (BBBL) {
				return BBL.depth + 1 < maxDepth ? findNode(mesh, BBL) : BBL;
			} else if (BBBR) {
				return BBR.depth + 1 < maxDepth ? findNode(mesh, BBR) : BBR;
			} else if (BTTL) {
				return TTL.depth + 1 < maxDepth ? findNode(mesh, TTL) : TTL;
			} else if (BTTR) {
				return TTR.depth + 1 < maxDepth ? findNode(mesh, TTR) : TTR;
			} else if (BTBL) {
				return TBL.depth + 1 < maxDepth ? findNode(mesh, TBL) : TBL;
			} else if (BTBR) {
				return TBR.depth + 1 < maxDepth ? findNode(mesh, TBR) : TBR;
			}
			return null;
		}
		
		public function create(target:IContainer3D, depth:int, size:Number):void {
			this.target = target;
			this.size = size;
			this.maxDepth = depth;
			
			var size:Number = size / 2;
			
			var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
			var meshes:Vector.<IMesh> = new Vector.<IMesh>();
			var container:IContainer3D = target;
			var offset:Vector3D = target.worldMatrix.position;
			
			var object:IObject3D;
			var i:int, j:int;
			
			while (container) {
				j = container.numChildren;
				for (i = 0; i < j; i++) {
					object = container.objects[i];
					if (object is IMesh) {
						meshes.push(object);
					} else if (object is IContainer3D) {
						containers.push(object);
					}
				}
				container = containers.pop();
				if (container && container.partition) throw new Error("Can't use partition tree inside another one.");
			}
			
			_root.dispose(this);
			_root.depth = 0;
			_root.parent = null;
			_root.objects = new Vector.<IMesh>();
			_root.max.setTo(  size + offset.x,  size + offset.y,  size + offset.z);
			_root.min.setTo( -size + offset.x, -size + offset.y, -size + offset.z);
			if (depth > 0) divide(_root, size, 1);
			
			j = meshes.length;
			for (i = 0; i < j; i++) addChild(meshes[i]);
		}
		
		private function divide(node:OcNode, size:int, depth:int):void {
			node.childs = new Vector.<OcNode>(8, true);
			
			var TTL:OcNode = node.childs[0] = new OcNode();
			var TTR:OcNode = node.childs[1] = new OcNode();
			var TBL:OcNode = node.childs[2] = new OcNode();
			var TBR:OcNode = node.childs[3] = new OcNode();
			var BTL:OcNode = node.childs[4] = new OcNode();
			var BTR:OcNode = node.childs[5] = new OcNode();
			var BBL:OcNode = node.childs[6] = new OcNode();
			var BBR:OcNode = node.childs[7] = new OcNode();
			
			var max:Vector3D = node.max, min:Vector3D = node.min;
			var center:Number = min.y + size;
			
			TTL.min.setTo(min.x, 			center, min.z + size);
			TTL.max.setTo(TTL.min.x + size, max.y, 	TTL.min.z + size);
			TTR.min.setTo(min.x + size, 	center, min.z + size);
			TTR.max.setTo(max.x,        	max.y, 	max.z);
			
			TBL.min.setTo(min.x,        	center, min.z);
			TBL.max.setTo(min.x + size, 	max.y, 	min.z + size);
			TBR.min.setTo(min.x + size, 	center,	min.z);
			TBR.max.setTo(TBR.min.x + size, max.y, 	TBR.min.z + size);
			
			BTL.min.setTo(TTL.min.x, 		min.y, 	TTL.min.z);
			BTL.max.setTo(TTL.max.x, 		center, TTL.max.z);
			BTR.min.setTo(TTR.min.x, 		min.y, 	TTR.min.z);
			BTR.max.setTo(TTR.max.x, 		center, TTR.max.z);
			
			BBL.min.setTo(TBL.min.x, 		min.y, 	TBL.min.z);
			BBL.max.setTo(TBL.max.x, 		center, TBL.max.z);
			BBR.min.setTo(TBR.min.x, 		min.y,	TBR.min.z);
			BBR.max.setTo(TBR.max.x, 		center,	TBR.max.z);
			
			TTL.parent = TTR.parent = TBL.parent = TBR.parent = node;
			TTL.depth = TTR.depth = TBL.depth = TBR.depth = depth;
			
			BTL.parent = BTR.parent = BBL.parent = BBR.parent = node;
			BTL.depth = BTR.depth = BBL.depth = BBR.depth = depth;
			
			if (depth + 1 < maxDepth) {
				divide(BTL, size / 2, depth + 1);
				divide(BTR, size / 2, depth + 1);
				divide(BBL, size / 2, depth + 1);
				divide(BBR, size / 2, depth + 1);
				divide(TTL, size / 2, depth + 1);
				divide(TTR, size / 2, depth + 1);
				divide(TBL, size / 2, depth + 1);
				divide(TBR, size / 2, depth + 1);
			}
 		}
		
		public function dispose():void {
			target = null;
			size = 0;
			maxDepth = 0;
			frustum = false;
			_root.dispose(this);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get root():OcNode {
			return _root;
		}
		
	}

}