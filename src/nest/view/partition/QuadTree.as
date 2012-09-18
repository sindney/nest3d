package nest.view.partition 
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
		
		public static function classifyBSphere(center:Vector3D, radius:Number, node:QuadNode):Boolean {
			if (center.x > max.x) {
				if (center.z > max.z) {
					return (center.z - node.max.z < radius);
				} else {
					return (center.x - node.max.x < radius);
				}
			} else {
				if (center.z > max.z) {
					return (center.z - node.max.z < radius);
				}
			}
			return true;
		}
		
		private var _root:QuadNode;
		
		public function QuadTree() {
			_root = new QuadNode();
		}
		
		/**
		 * Create tree.
		 * @param	data container:IContainer3D, size:Number, depth:int.
		 */
		public function create(data:Object):void {
			var size:Number = data.size / 2;
			
			var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
			var meshes:Vector.<IMesh> = new Vector.<IMesh>();
			var container:IContainer3D = data.container;
			
			var object:IObject3D;
			var i:int, j:int;
			
			while (container) {
				j = container.numChildren;
				for (i = 0; i < j; i++) {
					object = container.objects[i];
					if (object is IMesh) {
						_meshes.push(object);
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
			_root.max.setTo(size, 0, size);
			_root.min.setTo( -size, 0, -size);
			divide(_root, 1, data.depth);
		}
		
		private function divide(parent:QuadNode, depth:int, maxDepth:int):void {
			var TL:QuadNode = parent.childs[0] = EngineBase.getObject(QuadNode);
			var TR:QuadNode = parent.childs[1] = EngineBase.getObject(QuadNode);
			var BL:QuadNode = parent.childs[2] = EngineBase.getObject(QuadNode);
			var BR:QuadNode = parent.childs[3] = EngineBase.getObject(QuadNode);
			var size:Number = (parent.max.x - parent.max.z) / 2;
			
			TL.min.copyFrom(parent.min);
			TL.max.setTo(TL.min.x + size, 0, TL.min.z + size);
			TR.min.setTo(parent.min.x + size, 0, parent.min.z);
			TR.max.setTo(TR.min.x + size, 0, TR.min.z + size);
			BL.min.setTo(parent.min.x, 0, parent.min.z + size);
			BL.max.setTo(BL.min.x + size, 0, BL.min.z + size);
			BR.min.setTo(parent.min.x + size, 0, parent.min.z + size);
			BR.max.copyFrom(parent.max);
			
			TL.parent = TR.parent = BL.parent = BR.parent = parent;
			TL.depth = TR.depth = BL.depth = BR.depth = depth;
			
			var BTL:Boolean, BTR:Boolean, BBL:Boolean, BBR:Boolean;
			
			if (depth < maxDepth) {
				var i:int, j:int;
				var mesh:IMesh;
				var objects:Vector.<IMesh> = parent.objects;
				j = objects.length;
				parent.objects = new Vector.<IMesh>();
				for (i = 0; i < j; i++) {
					mesh = objects[i];
					BTL = BTR = BBL = BBR = false;
					if (mesh.bound is AABB) {
						BTL = classifyAABB(mesh.worldMatrix.transformVector((mesh.bound as AABB).max), 
							mesh.worldMatrix.transformVector((mesh.bound as AABB).max), TL);
						BTR = classifyAABB(mesh.worldMatrix.transformVector((mesh.bound as AABB).max), 
							mesh.worldMatrix.transformVector((mesh.bound as AABB).max), TR);
						BBL = classifyAABB(mesh.worldMatrix.transformVector((mesh.bound as AABB).max), 
							mesh.worldMatrix.transformVector((mesh.bound as AABB).max), BL);
						BBR = classifyAABB(mesh.worldMatrix.transformVector((mesh.bound as AABB).max), 
							mesh.worldMatrix.transformVector((mesh.bound as AABB).max), BR);
					} else {
						BTL = classifyBSphere(mesh.worldMatrix.transformVector(mesh.bound.center),
							(mesh.bound as BSphere).radius, TL);
						BTR = classifyBSphere(mesh.worldMatrix.transformVector(mesh.bound.center),
							(mesh.bound as BSphere).radius, TR);
						BBL = classifyBSphere(mesh.worldMatrix.transformVector(mesh.bound.center),
							(mesh.bound as BSphere).radius, BL);
						BBR = classifyBSphere(mesh.worldMatrix.transformVector(mesh.bound.center),
							(mesh.bound as BSphere).radius, BR);
					}
					
					if (BTL && (BTR || BBL || BBR) || BTR && (BTL || BBL || BBR) || 
						BBL && (BTL || BTR || BBR) || BBR && (BTL || BTR || BBL)) {
						parent.objects.push(mesh);
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
					if (TL.objects) divide(TL, depth + 1, maxDepth);
					if (TR.objects) divide(TR, depth + 1, maxDepth);
					if (BL.objects) divide(BL, depth + 1, maxDepth);
					if (BR.objects) divide(BR, depth + 1, maxDepth);
				}
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