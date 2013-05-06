package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	import nest.object.geom.Bound;
	import nest.object.Mesh;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	
	/**
	 * QuadTree
	 */
	public class QuadTree implements IPTree {
		
		private var _root:QuadNode;
		private var _frustum:Boolean = false;
		
		public function QuadTree() {
			_root = new QuadNode();
		}
		
		public function create(target:IContainer3D, depth:int, size:Number):void {
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
			
			_root.dispose();
			_root.depth = 0;
			_root.parent = null;
			_root.objects = meshes;
			_root.max.setTo(size + offset.x, 0, size + offset.z);
			_root.min.setTo( -size + offset.x, 0, -size + offset.z);
			_root.vertices[1].setTo(_root.max.x, 0, _root.min.z);
			_root.vertices[2].setTo(_root.min.x, 0, _root.max.z);
			if (depth > 0) divide(_root, size, 1, depth);
		}
		
		private function divide(node:QuadNode, size:int, depth:int, maxDepth:int):void {
			var TL:QuadNode = new QuadNode();
			var TR:QuadNode = new QuadNode();
			var BL:QuadNode = new QuadNode();
			var BR:QuadNode = new QuadNode();
			
			node.childs[0] = TL;
			node.childs[1] = TR;
			node.childs[2] = BL;
			node.childs[3] = BR;
			
			TL.min.setTo(node.min.x, 0, node.min.z + size);
			TL.max.setTo(TL.min.x + size, 0, TL.min.z + size);
			TR.min.setTo(node.min.x + size, 0, node.min.z + size);
			TR.max.copyFrom(node.max);
			
			BL.min.copyFrom(node.min);
			BL.max.copyFrom(TR.min);
			BR.min.setTo(node.min.x + size, 0, node.min.z);
			BR.max.setTo(BR.min.x + size, 0, BR.min.z + size);
			
			TL.parent = TR.parent = BL.parent = BR.parent = node;
			TL.depth = TR.depth = BL.depth = BR.depth = depth;
			
			var i:int, j:int;
			for (i = 0; i < 4; i++) {
				var tmp:QuadNode = node.childs[i] as QuadNode;
				tmp.vertices[1].setTo(tmp.max.x, 0, tmp.min.z);
				tmp.vertices[2].setTo(tmp.min.x, 0, tmp.max.z);
			}
			
			var BTL:Boolean, BTR:Boolean, BBL:Boolean, BBR:Boolean;
			
			var mesh:IMesh;
			var objects:Vector.<IMesh> = node.objects;
			var a:Vector3D, b:Vector3D;
			
			j = objects.length;
			node.objects = new Vector.<IMesh>();
			
			for (i = 0; i < j; i++) {
				mesh = objects[i];
				BTL = BTR = BBL = BBR = false;
				a = mesh.bound.vertices[7].clone();
				b = mesh.bound.vertices[0].clone();
				a.y = b.y = 0;
				BTL = Bound.AABB_AABB(a, b, TL.max, TL.min);
				BTR = Bound.AABB_AABB(a, b, TR.max, TR.min);
				BBL = Bound.AABB_AABB(a, b, BL.max, BL.min);
				BBR = Bound.AABB_AABB(a, b, BR.max, BR.min);
				
				if (BTL && (BTR || BBL || BBR) || BTR && (BTL || BBL || BBR) || 
					BBL && (BTL || BTR || BBR) || BBR && (BTL || BTR || BBL)) {
					node.objects.push(mesh);
				} else if (BTL) {
					if (!TL.objects) TL.objects = new Vector.<IMesh>();
					TL.objects.push(mesh);
				} else if (BTR) {
					if (!TR.objects) TR.objects = new Vector.<IMesh>();
					TR.objects.push(mesh);
				} else if (BBL) {
					if (!BL.objects) BL.objects = new Vector.<IMesh>();
					BL.objects.push(mesh);
				} else if (BBR) {
					if (!BR.objects) BR.objects = new Vector.<IMesh>();
					BR.objects.push(mesh);
				}
			}
			
			if (depth + 1 < maxDepth) {
				if (TL.objects) divide(TL, size / 2, depth + 1, maxDepth);
				if (TR.objects) divide(TR, size / 2, depth + 1, maxDepth);
				if (BL.objects) divide(BL, size / 2, depth + 1, maxDepth);
				if (BR.objects) divide(BR, size / 2, depth + 1, maxDepth);
			}
 		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get root():IPNode {
			return _root;
		}
		
		public function get frustum():Boolean {
			return _frustum;
		}
		
		public function set frustum(value:Boolean):void {
			_frustum = value;
		}
		
	}

}