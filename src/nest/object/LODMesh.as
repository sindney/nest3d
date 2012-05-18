package nest.object 
{
	import flash.geom.Vector3D;
	
	import nest.object.data.MeshData;
	import nest.object.geom.BSphere;
	import nest.object.geom.IBound;
	import nest.view.materials.IMaterial;
	import nest.view.Shader3D;
	
	/**
	 * LODMesh
	 */
	public class LODMesh extends Mesh {
		
		protected var _dataList:Vector.<MeshData>;
		protected var _materialList:Vector.<IMaterial>;
		protected var _distantList:Vector.<Number>;
		
		protected var _index:int = 0;
		
		public function LODMesh(dataList:Vector.<MeshData>, materialList:Vector.<IMaterial>, distantList:Vector.<Number>, shader:Shader3D, bound:IBound = null) {
			super(null, null, shader, bound);
			reset(dataList, materialList, distantList);
		}
		
		public function addChild(data:MeshData, material:IMaterial, distant:Number):void {
			_dataList.push(data);
			_materialList.push(material);
			_distantList.push(distant);
		}
		
		public function reset(dataList:Vector.<MeshData>, materialList:Vector.<IMaterial>, distantList:Vector.<Number>):void {
			_dataList = dataList;
			_materialList = materialList;
			_distantList = distantList;
			if (_dataList) {
				data = _dataList[_index];
				_bound.update(_data.vertices);
			}
			if (_materialList) material = _materialList[_index];
		}
		
		public function update(camera:Vector3D):void {
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
			var result:LODMesh = new LODMesh(_dataList, _materialList, _distantList, _shader, bound);
			result.blendMode.source = _blendMode.source;
			result.blendMode.dest = _blendMode.dest;
			result.blendMode.depthMask = _blendMode.depthMask;
			result.cliping = _cliping;
			result.culling = _culling;
			result.visible = _visible;
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
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		override public function toString():String {
			return "[nest.object.LODMesh]";
		}
		
	}

}