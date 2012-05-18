package nest.object
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	import nest.object.data.MeshData;
	import nest.object.geom.Vertex;
	import nest.object.geom.IBound;
	import nest.object.geom.BSphere;
	import nest.view.materials.IMaterial;
	import nest.view.Shader3D;
	
	/**
	 * Terrain
	 */
	public class Terrain extends Mesh {
		
		public var heightMap:BitmapData;
		
		public var width:Number;
		public var height:Number;
		public var segmentsW:int;
		public var segmentsH:int;
		public var magnitude:Number;
		
		public function Terrain(data:MeshData, material:IMaterial, shader:Shader3D, bound:IBound = null) {
			super(data, material, shader, bound);
		}
		
		/**
		 * Call this when you modified terrain's heightMap, meshData, width ... magnitude.
		 */
		public function update():void {
			const dw:Number = heightMap.width / segmentsW;
			const dh:Number = heightMap.height / segmentsH;
			
			var p1:int, p2:int, p3:int, p4:int;
			var i:int, j:int, k:int;
			for (i = 0; i < segmentsW; i++) {
				for (j = 0; j < segmentsH; j++) {
					k = i * (segmentsH + 1) + j;
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					_data.vertices[p1].y = ((heightMap.getPixel(i * dw, j * dh) & 0xff) - 128) * magnitude;
					_data.vertices[p2].y = ((heightMap.getPixel(i * dw, (j + 1) * dh) & 0xff) - 128) * magnitude;
					_data.vertices[p3].y = ((heightMap.getPixel((i + 1) * dw, j * dh) & 0xff) - 128) * magnitude;
					_data.vertices[p4].y = ((heightMap.getPixel((i + 1) * dw, (j + 1) * dh) & 0xff) - 128) * magnitude;
				}
			}
			
			_data.update();
			_bound.update(_data.vertices);
		}
		
		public function getHeight(position:Vector3D):void {
			_matrix.transformVector(position);
			const x:Number = Math.round((position.x + width * 0.5) / width * heightMap.width);
			const z:Number = Math.round((position.z + height * 0.5) / height * heightMap.height);
			position.y = ((heightMap.getPixel(x, z) & 0xff) - 128) * magnitude;
			_invertMatrix.transformVector(position);
		}
		
		override public function clone():IMesh {
			var bound:IBound;
			if (_bound is BSphere) bound = new BSphere(); 
			var result:Terrain = new Terrain(_data, _material, _shader, bound);
			result.width = width;
			result.height = height;
			result.segmentsW = segmentsW;
			result.segmentsH = segmentsH;
			result.magnitude = magnitude;
			result.blendMode.source = _blendMode.source;
			result.blendMode.dest = _blendMode.dest;
			result.blendMode.depthMask = _blendMode.depthMask;
			result.cliping = _cliping;
			result.culling = _culling;
			result.visible = _visible;
			return result;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		override public function toString():String {
			return "[nest.object.Terrain]";
		}
		
	}
	
}