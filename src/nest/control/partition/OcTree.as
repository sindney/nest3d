package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	import nest.object.geom.Bound;
	import nest.object.Mesh;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	
	/**
	 * OcTree
	 * <p>OcTree divides meshes in specific container to cubes.</p>
	 * <p>If any of the container's child mesh's transform matrix is changed, you should regenerate the tree.</p>
	 * <p>So you'd better put only constant meshes here.</p>
	 */
	public class OcTree implements IPTree {
		
		private var _root:OcNode;
		
		public function OcTree() {
			_root = new OcNode();
		}
		
		public function create(target:IContainer3D, depth:int, size:Number, offsetX:Number = 0, offsetY:Number = 0, offsetZ:Number = 0):void {
			var size:Number = size / 2;
			
			var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
			var meshes:Vector.<IMesh> = new Vector.<IMesh>();
			var container:IContainer3D = target;
			
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
			}
			
			_root.dispose();
			_root.depth = 0;
			_root.parent = null;
			_root.objects = meshes;
			_root.max.setTo(  size + offsetX,  size + offsetY,  size + offsetZ);
			_root.min.setTo( -size + offsetX, -size + offsetY, -size + offsetZ);
			_root.vertices[1].setTo(_root.max.x, _root.min.y, _root.min.z);
			_root.vertices[2].setTo(_root.min.x, _root.max.y, _root.min.z);
			_root.vertices[3].setTo(_root.max.x, _root.max.y, _root.min.z);
			_root.vertices[4].setTo(_root.min.x, _root.min.y, _root.max.z);
			_root.vertices[5].setTo(_root.max.x, _root.min.y, _root.max.z);
			_root.vertices[6].setTo(_root.min.x, _root.max.y, _root.max.z);
			if (depth > 0) divide(_root, size, 1, depth);
		}
		
		private function divide(node:OcNode, size:int, depth:int, maxDepth:int):void {
			var TTL:OcNode = new OcNode();
			var TTR:OcNode = new OcNode();
			var TBL:OcNode = new OcNode();
			var TBR:OcNode = new OcNode();
			var BTL:OcNode = new OcNode();
			var BTR:OcNode = new OcNode();
			var BBL:OcNode = new OcNode();
			var BBR:OcNode = new OcNode();
			
			node.childs[0] = TTL;
			node.childs[1] = TTR;
			node.childs[2] = TBL;
			node.childs[3] = TBR;
			node.childs[4] = BTL;
			node.childs[5] = BTR;
			node.childs[6] = BBL;
			node.childs[7] = BBR;
			
			var center:Number = node.min.y + size;
			
			TTL.min.setTo(node.min.x,        center,     node.min.z + size);
			TTL.max.setTo(TTL.min.x + size,  node.max.y, TTL.min.z + size);
			TTR.min.setTo(node.min.x + size, center,     node.min.z + size);
			TTR.max.setTo(node.max.x,        node.max.y, node.max.z);
			
			TBL.min.setTo(node.min.x,        center,     node.min.z);
			TBL.max.setTo(node.min.x + size, node.max.y, node.min.z + size);
			TBR.min.setTo(node.min.x + size, center,     node.min.z);
			TBR.max.setTo(TBR.min.x + size,  node.max.y, TBR.min.z + size);
			
			BTL.min.setTo(TTL.min.x, node.min.y, TTL.min.z);
			BTL.max.setTo(TTL.max.x, center,     TTL.max.z);
			BTR.min.setTo(TTR.min.x, node.min.y, TTR.min.z);
			BTR.max.setTo(TTR.max.x, center,     TTR.max.z);
			
			BBL.min.setTo(TBL.min.x, node.min.y, TBL.min.z);
			BBL.max.setTo(TBL.max.x, center,     TBL.max.z);
			BBR.min.setTo(TBR.min.x, node.min.y, TBR.min.z);
			BBR.max.setTo(TBR.max.x, center,     TBR.max.z);
			
			TTL.parent = TTR.parent = TBL.parent = TBR.parent = node;
			TTL.depth = TTR.depth = TBL.depth = TBR.depth = depth;
			
			BTL.parent = BTR.parent = BBL.parent = BBR.parent = node;
			BTL.depth = BTR.depth = BBL.depth = BBR.depth = depth;
			
			var i:int, j:int;
			for (i = 0; i < 8; i++) {
				var tmp:OcNode = node.childs[i] as OcNode;
				tmp.vertices[1].setTo(tmp.max.x, tmp.min.y, tmp.min.z);
				tmp.vertices[2].setTo(tmp.min.x, tmp.max.y, tmp.min.z);
				tmp.vertices[3].setTo(tmp.max.x, tmp.max.y, tmp.min.z);
				tmp.vertices[4].setTo(tmp.min.x, tmp.min.y, tmp.max.z);
				tmp.vertices[5].setTo(tmp.max.x, tmp.min.y, tmp.max.z);
				tmp.vertices[6].setTo(tmp.min.x, tmp.max.y, tmp.max.z);
			}
			
			var BBTL:Boolean, BBTR:Boolean, BBBL:Boolean, BBBR:Boolean;
			var BTTL:Boolean, BTTR:Boolean, BTBL:Boolean, BTBR:Boolean;
			
			var radius:Number;
			var mesh:IMesh;
			var objects:Vector.<IMesh> = node.objects;
			var a:Vector3D, b:Vector3D, c:Vector3D = new Vector3D(0.577, 0.577, 0.577);
			
			j = objects.length;
			node.objects = new Vector.<IMesh>();
			
			for (i = 0; i < j; i++) {
				mesh = objects[i];
				BBTL = BBTR = BBBL = BBBR = false;
				BTTL = BTTR = BTBL = BTBR = false;
				if (mesh.bound.aabb) {
					a = mesh.worldMatrix.transformVector(mesh.matrix.transformVector(mesh.bound.vertices[7]));
					b = mesh.worldMatrix.transformVector(mesh.matrix.transformVector(mesh.bound.vertices[0]));
					BBTL = Bound.AABB_AABB(a, b, BTL.max, BTL.min);
					BBTR = Bound.AABB_AABB(a, b, BTR.max, BTR.min);
					BBBL = Bound.AABB_AABB(a, b, BBL.max, BBL.min);
					BBBR = Bound.AABB_AABB(a, b, BBR.max, BBR.min);
					BTTL = Bound.AABB_AABB(a, b, TTL.max, TTL.min);
					BTTR = Bound.AABB_AABB(a, b, TTR.max, TTR.min);
					BTBL = Bound.AABB_AABB(a, b, TBL.max, TBL.min);
					BTBR = Bound.AABB_AABB(a, b, TBR.max, TBR.min);
				} else {
					a = mesh.worldMatrix.transformVector(mesh.matrix.transformVector(mesh.bound.center));
					b = mesh.worldMatrix.transformVector(mesh.matrix.transformVector(c));
					radius = mesh.bound.radius * b.length;
					BBTL = Bound.AABB_BSphere(BTL.max, BTL.min, a, radius);
					BBTR = Bound.AABB_BSphere(BTR.max, BTR.min, a, radius);
					BBBL = Bound.AABB_BSphere(BBL.max, BBL.min, a, radius);
					BBBR = Bound.AABB_BSphere(BBR.max, BBR.min, a, radius);
					BTTL = Bound.AABB_BSphere(TTL.max, TTL.min, a, radius);
					BTTR = Bound.AABB_BSphere(TTR.max, TTR.min, a, radius);
					BTBL = Bound.AABB_BSphere(TBL.max, TBL.min, a, radius);
					BTBR = Bound.AABB_BSphere(TBR.max, TBR.min, a, radius);
				}
				
				if (BBTL && (BBTR || BBBL || BBBR || BTTL || BTTR || BTBL || BTBR) || 
					BBTR && (BBTL || BBBL || BBBR || BTTL || BTTR || BTBL || BTBR) || 
					BBBL && (BBTL || BBTR || BBBR || BTTL || BTTR || BTBL || BTBR) || 
					BBBR && (BBTL || BBTR || BBBL || BTTL || BTTR || BTBL || BTBR) || 
					BTTL && (BTTR || BTBL || BTBR || BBTL || BBTR || BBBL || BBBR) || 
					BTTR && (BTTL || BTBL || BTBR || BBTL || BBTR || BBBL || BBBR) || 
					BTBL && (BTTL || BTTR || BTBR || BBTL || BBTR || BBBL || BBBR) || 
					BTBR && (BTTL || BTTR || BTBL || BBTL || BBTR || BBBL || BBBR)) {
					node.objects.push(mesh);
				} else if (BBTL) {
					if (!BTL.objects) BTL.objects = new Vector.<IMesh>();
					BTL.objects.push(mesh);
				} else if (BBTR) {
					if (!BTR.objects) BTR.objects = new Vector.<IMesh>();
					BTR.objects.push(mesh);
				} else if (BBBL) {
					if (!BBL.objects) BBL.objects = new Vector.<IMesh>();
					BBL.objects.push(mesh);
				} else if (BBBR) {
					if (!BBR.objects) BBR.objects = new Vector.<IMesh>();
					BBR.objects.push(mesh);
				} else if (BTTL) {
					if (!TTL.objects) TTL.objects = new Vector.<IMesh>();
					TTL.objects.push(mesh);
				} else if (BTTR) {
					if (!TTR.objects) TTR.objects = new Vector.<IMesh>();
					TTR.objects.push(mesh);
				} else if (BTBL) {
					if (!TBL.objects) TBL.objects = new Vector.<IMesh>();
					TBL.objects.push(mesh);
				} else if (BTBR) {
					if (!TBR.objects) TBR.objects = new Vector.<IMesh>();
					TBR.objects.push(mesh);
				}
			}
			
			if (depth + 1 < maxDepth) {
				if (BTL.objects) divide(BTL, size / 2, depth + 1, maxDepth);
				if (BTR.objects) divide(BTR, size / 2, depth + 1, maxDepth);
				if (BBL.objects) divide(BBL, size / 2, depth + 1, maxDepth);
				if (BBR.objects) divide(BBR, size / 2, depth + 1, maxDepth);
				if (TTL.objects) divide(TTL, size / 2, depth + 1, maxDepth);
				if (TTR.objects) divide(TTR, size / 2, depth + 1, maxDepth);
				if (TBL.objects) divide(TBL, size / 2, depth + 1, maxDepth);
				if (TBR.objects) divide(TBR, size / 2, depth + 1, maxDepth);
			}
 		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get root():IPNode {
			return _root;
		}
		
	}

}