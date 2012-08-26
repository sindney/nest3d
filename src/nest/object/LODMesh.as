package nest.object 
{
	import flash.geom.Vector3D;
	
	import nest.control.EngineBase;
	import nest.object.data.MeshData;
	import nest.object.geom.BSphere;
	import nest.object.geom.IBound;
	import nest.view.materials.IMaterial;
	import nest.view.Shader3D;
	
	/**
	 * LODMesh
	 */
	public class LODMesh extends Mesh {
		
		private var _dataList:Vector.<MeshData>;
		private var _materialList:Vector.<IMaterial>;
		private var _distantList:Vector.<Number>;
		
		private var _index:int = 0;
		
		public function LODMesh(dataList:Vector.<MeshData>, materialList:Vector.<IMaterial>, distantList:Vector.<Number>, bound:IBound = null) {
			super(null, null, bound);
			_dataList = dataList;
			_materialList = materialList;
			_distantList = distantList;
			_bound.update(_dataList[0].vertices);
		}
		
		public function update():void {
			const camera:Vector3D = EngineBase.camera.position;
			const dx:Number = position.x - camera.x;
			const dy:Number = position.y - camera.y;
			const dz:Number = position.z - camera.z;
			const d:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
			var i:int, l:int = _dataList.length;
			_index = l - 1;
			for (i = 0; i < l; i++) {
				if (d < _distantList[i]) {
					_index = i;
					data = _dataList[i];
					material = _materialList[i];
					break;
				}
			}
		}
		
		override public function clone():IMesh {
			var bound:IBound;
			if (_bound is BSphere) bound = new BSphere(); 
			var result:LODMesh = new LODMesh(_dataList, _materialList, _distantList, bound);
			result.blendMode.source = _blendMode.source;
			result.blendMode.dest = _blendMode.dest;
			result.blendMode.depthMask = _blendMode.depthMask;
			result.cliping = _cliping;
			result.culling = _culling;
			result.visible = _visible;
			result.alphaTest = _alphaTest;
			return result;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		override public function set data(value:MeshData):void {
			if (_data != value)_data = value;
		}
		
		public function get index():int {
			return _index;
		}
		
		public function get dataList():Vector.<MeshData> {
			return _dataList;
		}
		
		public function get materialList():Vector.<IMaterial> {
			return _materialList;
		}
		
		public function get distantList():Vector.<Number> {
			return _distantList;
		}
		
	}

}