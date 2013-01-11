package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	import nest.control.EngineBase;
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.Mesh;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	
	/**
	 * QuadTree
	 * <p>QuadTree divides constant meshes in specific container.</p>
	 * <p>If any of the container's child mesh's transform matrix is changed, you should regenerate the tree.</p>
	 * <p>So you'd better put only constant meshes here.</p>
	 */
	public class QuadTree implements IPTree {
		
		public static function classifyAABB(max:Vector3D, min:Vector3D, node:QuadNode):Boolean {
			if (max.x > node.max.x) {
				if (max.z > node.max.z) {
					return (min.x < node.max.x && min.z < node.max.z);
				} else {
					return (min.x < node.max.x && min.z > node.min.z);
				}
			} else {
				if (max.z > node.max.z) {
					return (min.z < node.max.z);
				}
			}
			return true;
		}
		
		// TODO: 注意半径要乘mesh缩放
		public static function classifyBSphere(center:Vector3D, radius:Number, node:QuadNode):Boolean {
			if (center.x > node.max.x) {
				if (center.z > node.max.z) {
					return (center.z - node.max.z < radius);
				} else {
					return (center.x - node.max.x < radius);
				}
			} else {
				if (center.z > node.max.z) {
					return (center.z - node.max.z < radius);
				}
			}
			return true;
		}
		
		private var _root:QuadNode;
		private var _nonMeshes:Vector.<IObject3D>;
		
		public function QuadTree() {
			_root = new QuadNode();
		}
		
		public function create(target:IContainer3D, size:Number, depth:int):void {
			var size:Number = size / 2;
			
			var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
			var meshes:Vector.<IMesh> = new Vector.<IMesh>();
			var container:IContainer3D = target;
			
			var object:IObject3D;
			var i:int, j:int;
			
			_nonMeshes = new Vector.<IObject3D>();
			
			while (container) {
				j = container.numChildren;
				for (i = 0; i < j; i++) {
					object = container.objects[i];
					if (object is IMesh) {
						meshes.push(object);
					} else if (object is IContainer3D) {
						containers.push(object);
					} else {
						_nonMeshes.push(object);
					}
				}
				container = containers.pop();
			}
			
			_root.dispose();
			_root.depth = 0;
			_root.parent = null;
			_root.objects = meshes;
			_root.max.setTo(size, 0, size);
			_root.min.setTo( -size, 0, -size);
			divide(_root, 1, depth);
		}
		
		private function divide(node:QuadNode, depth:int, maxDepth:int):void {
			var TL:QuadNode = EngineBase.getObject(QuadNode);
			var TR:QuadNode = EngineBase.getObject(QuadNode);
			var BL:QuadNode = EngineBase.getObject(QuadNode);
			var BR:QuadNode = EngineBase.getObject(QuadNode);
			var size:Number = (node.max.x - node.min.x) / 2;
			
			node.childs[0] = TL;
			node.childs[1] = TR;
			node.childs[2] = BL;
			node.childs[3] = BR;
			
			TL.min.setTo(node.min.x, 0, node.min.z + size);
			TL.max.setTo(TL.min.x + size, 0, TL.min.z + size);
			TR.min.setTo(node.min.x + size, 0, node.min.z + size);
			TR.max.copyFrom(node.max);
			
			BL.min.copyFrom(node.min);
			BL.max.setTo(BL.min.x + size, 0, BL.min.z + size);
			BR.min.setTo(node.min.x + size, 0, node.min.z);
			BR.max.setTo(BR.min.x + size, 0, BR.min.z + size);
			
			TL.parent = TR.parent = BL.parent = BR.parent = node;
			TL.depth = TR.depth = BL.depth = BR.depth = depth;
			
			var BTL:Boolean, BTR:Boolean, BBL:Boolean, BBR:Boolean;
			
			var i:int, j:int, l:int;
			var mesh:IMesh;
			var objects:Vector.<IMesh> = node.objects;
			var a:Vector3D, b:Vector3D;
			
			j = objects.length;
			node.objects = null;
			node.objects = new Vector.<IMesh>();
			
			for (i = 0; i < j; i++) {
				mesh = objects[i];
				BTL = BTR = BBL = BBR = false;
				if (mesh.bound is AABB) {
					a = mesh.worldMatrix.transformVector((mesh.bound as AABB).max);
					b = mesh.worldMatrix.transformVector((mesh.bound as AABB).min);
					BTL = classifyAABB(a, b, TL);
					BTR = classifyAABB(a, b, TR);
					BBL = classifyAABB(a, b, BL);
					BBR = classifyAABB(a, b, BR);
				} else {
					a = mesh.worldMatrix.transformVector(mesh.bound.center);
					l = (mesh.bound as BSphere).radius;
					BTL = classifyBSphere(a, l, TL);
					BTR = classifyBSphere(a, l, TR);
					BBL = classifyBSphere(a, l, BL);
					BBR = classifyBSphere(a, l, BR);
				}
				
				if (BTL && (BTR || BBL || BBR) || BTR && (BTL || BBL || BBR) || 
					BBL && (BTL || BTR || BBR) || BBR && (BTL || BTR || BBL)) {
					node.objects.push(mesh);
				} else if (BTL) {
					TL.objects = new Vector.<IMesh>();
					TL.objects.push(mesh);
				} else if (BTR) {
					TR.objects = new Vector.<IMesh>();
					TR.objects.push(mesh);
				} else if (BBL) {
					BL.objects = new Vector.<IMesh>();
					BL.objects.push(mesh);
				} else if (BBR) {
					BR.objects = new Vector.<IMesh>();
					BR.objects.push(mesh);
				}
			}
			
			if (depth + 1 < maxDepth) {
				if (TL.objects.length > 0) divide(TL, depth + 1, maxDepth);
				if (TR.objects.length > 0) divide(TR, depth + 1, maxDepth);
				if (BL.objects.length > 0) divide(BL, depth + 1, maxDepth);
				if (BR.objects.length > 0) divide(BR, depth + 1, maxDepth);
			}
 		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get root():IPNode {
			return _root;
		}
		
		public function get nonMeshes():Vector.<IObject3D> {
			return _nonMeshes;
		}
		
	}

}