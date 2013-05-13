package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	import nest.control.event.MatrixEvent;
	import nest.object.geom.Bound;
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
		public var ignorePosition:Boolean = false;
		
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
			var a:Vector3D = mesh.bound.vertices[7];
			var b:Vector3D = mesh.bound.vertices[0];
			var TTL:OcNode = node.childs[0];
			var TTR:OcNode = node.childs[1];
			var TBL:OcNode = node.childs[2];
			var TBR:OcNode = node.childs[3];
			var BTL:OcNode = node.childs[4];
			var BTR:OcNode = node.childs[5];
			var BBL:OcNode = node.childs[6];
			var BBR:OcNode = node.childs[7];
			var	BBTL:Boolean = Bound.AABB_AABB(a, b, BTL.bound[7], BTL.bound[0]);
			var	BBTR:Boolean = Bound.AABB_AABB(a, b, BTR.bound[7], BTR.bound[0]);
			var	BBBL:Boolean = Bound.AABB_AABB(a, b, BBL.bound[7], BBL.bound[0]);
			var	BBBR:Boolean = Bound.AABB_AABB(a, b, BBR.bound[7], BBR.bound[0]);
			var	BTTL:Boolean = Bound.AABB_AABB(a, b, TTL.bound[7], TTL.bound[0]);
			var	BTTR:Boolean = Bound.AABB_AABB(a, b, TTR.bound[7], TTR.bound[0]);
			var	BTBL:Boolean = Bound.AABB_AABB(a, b, TBL.bound[7], TBL.bound[0]);
			var	BTBR:Boolean = Bound.AABB_AABB(a, b, TBR.bound[7], TBR.bound[0]);
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
			var max:Vector3D = _root.bound[7], min:Vector3D = _root.bound[0];
			max.setTo(  size + offset.x,  size + offset.y,  size + offset.z);
			min.setTo( -size + offset.x, -size + offset.y, -size + offset.z);
			_root.bound[1].setTo(max.x, min.y, min.z);
			_root.bound[2].setTo(min.x, max.y, min.z);
			_root.bound[3].setTo(max.x, max.y, min.z);
			_root.bound[4].setTo(min.x, min.y, max.z);
			_root.bound[5].setTo(max.x, min.y, max.z);
			_root.bound[6].setTo(min.x, max.y, max.z);
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
			
			var max:Vector3D = node.bound[7], min:Vector3D = node.bound[0];
			var center:Number = min.y + size;
			
			TTL.bound[0].setTo(min.x, 					center, min.z + size);
			TTL.bound[7].setTo(TTL.bound[0].x + size, 	max.y, 	TTL.bound[0].z + size);
			TTR.bound[0].setTo(min.x + size, 			center, min.z + size);
			TTR.bound[7].setTo(max.x,        			max.y, 	max.z);
			
			TBL.bound[0].setTo(min.x,        			center, min.z);
			TBL.bound[7].setTo(min.x + size, 			max.y, 	min.z + size);
			TBR.bound[0].setTo(min.x + size, 			center,	min.z);
			TBR.bound[7].setTo(TBR.bound[0].x + size,  	max.y, 	TBR.bound[0].z + size);
			
			BTL.bound[0].setTo(TTL.bound[0].x, 			min.y, 	TTL.bound[0].z);
			BTL.bound[7].setTo(TTL.bound[7].x, 			center, TTL.bound[7].z);
			BTR.bound[0].setTo(TTR.bound[0].x, 			min.y, 	TTR.bound[0].z);
			BTR.bound[7].setTo(TTR.bound[7].x, 			center, TTR.bound[7].z);
			
			BBL.bound[0].setTo(TBL.bound[0].x, 			min.y, 	TBL.bound[0].z);
			BBL.bound[7].setTo(TBL.bound[7].x, 			center, TBL.bound[7].z);
			BBR.bound[0].setTo(TBR.bound[0].x, 			min.y,	TBR.bound[0].z);
			BBR.bound[7].setTo(TBR.bound[7].x, 			center,	TBR.bound[7].z);
			
			TTL.parent = TTR.parent = TBL.parent = TBR.parent = node;
			TTL.depth = TTR.depth = TBL.depth = TBR.depth = depth;
			
			BTL.parent = BTR.parent = BBL.parent = BBR.parent = node;
			BTL.depth = BTR.depth = BBL.depth = BBR.depth = depth;
			
			var i:int;
			var tmp:OcNode;
			for (i = 0; i < 8; i++) {
				tmp = node.childs[i];
				max = tmp.bound[7], min = tmp.bound[0];
				tmp.bound[1].setTo(max.x, min.y, min.z);
				tmp.bound[2].setTo(min.x, max.y, min.z);
				tmp.bound[3].setTo(max.x, max.y, min.z);
				tmp.bound[4].setTo(min.x, min.y, max.z);
				tmp.bound[5].setTo(max.x, min.y, max.z);
				tmp.bound[6].setTo(min.x, max.y, max.z);
			}
			
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
			ignorePosition = false;
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