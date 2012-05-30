package nest.object
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.data.MeshData;
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.geom.IBound;
	import nest.object.geom.Vertex;
	import nest.view.materials.IMaterial;
	import nest.view.BlendMode3D;
	import nest.view.Shader3D;
	
	/**
	 * Mesh
	 */
	public class Mesh extends Object3D implements IMesh {
		
		protected var _material:IMaterial;
		
		protected var _data:MeshData;
		
		protected var _shader:Shader3D;
		
		protected var _bound:IBound;
		
		protected var _culling:String = Context3DTriangleFace.BACK;
		
		protected var _blendMode:BlendMode3D;
		
		protected var _visible:Boolean = true;
		protected var _cliping:Boolean = true;
		
		public function Mesh(data:MeshData, material:IMaterial, shader:Shader3D, bound:IBound = null) {
			super();
			_shader = shader;
			_material = material;
			_blendMode = new BlendMode3D();
			
			if (bound) {
				_bound = bound;
			} else {
				_bound = new AABB();
			}
			
			this.data = data;
		}
		
		public function draw(context3D:Context3D, matrix:Matrix3D):void {
			context3D.setCulling(_culling);
			context3D.setBlendFactors(_blendMode.source, _blendMode.dest);
			context3D.setDepthTest(_blendMode.depthMask, Context3DCompareMode.LESS);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 23, _invertMatrix, true);
			
			_data.upload(context3D, _material.uv, _shader.normal);
			_material.upload(context3D);
			_shader.update(context3D);
			
			context3D.setProgram(_shader.program);
			context3D.drawTriangles(_data.indexBuffer);
			
			_data.unload(context3D);
			_material.unload(context3D);
		}
		
		public function clone():IMesh {
			var bound:IBound;
			if (_bound is BSphere) bound = new BSphere(); 
			var result:Mesh = new Mesh(_data, _material, _shader, bound);
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
		
		public function get visible():Boolean {
			return _visible;
		}
		
		public function set visible(value:Boolean):void {
			_visible = value;
		}
		
		public function get data():MeshData {
			return _data;
		}
		
		public function set data(value:MeshData):void {
			if (_data != value) {
				_data = value;
				if (_data) _bound.update(_data.vertices);
			}
		}
		
		public function get material():IMaterial {
			return _material;
		}
		
		public function set material(value:IMaterial):void {
			if (_material != value)_material = value;
		}
		
		public function get bound():IBound {
			return _bound;
		}
		
		public function get cliping():Boolean {
			return _cliping;
		}
		
		public function set cliping(value:Boolean):void {
			_cliping = value;
		}
		
		public function get culling():String {
			return _culling;
		}
		
		public function set culling(value:String):void {
			_culling = value;
		}
		
		public function get blendMode():BlendMode3D {
			return _blendMode;
		}
		
		public function get shader():Shader3D {
			return _shader;
		}
		
		public function set shader(value:Shader3D):void {
			if (_shader != value)_shader = value;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		override public function toString():String {
			return "[nest.object.Mesh]";
		}
		
	}

}