package nest.view.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.VertexBuffer3D;
	
	import nest.view.Shader3D;
	
	/**
	 * PostEffect
	 */
	public class PostEffect implements IPostEffect {
		
		protected var _texture:TextureBase;
		protected var _context3d:Context3D;
		protected var _next:IPostEffect;
		
		protected var width:Number = 0;
		protected var height:Number = 0;
		
		protected var program:Program3D;
		
		protected var vertexData:Vector.<Number>;
		protected var vertexBuffer:VertexBuffer3D;
		protected var uvData:Vector.<Number>;
		protected var uvBuffer:VertexBuffer3D;
		protected var indexData:Vector.<uint>;
		protected var indexBuffer:IndexBuffer3D;
		
		public function PostEffect() {
			vertexData = Vector.<Number>([-1, 1, 0, -1, -1, 0, 1, -1, 0, 1, 1, 0]);
			uvData = Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 0]);
			indexData = Vector.<uint>([0, 1, 2, 2, 3, 0]);
		}
		
		public function createTexture(width:Number, height:Number):void {
			if (width == 0 || height == 0) {
				this.width = this.height = 0;
				if (_texture) _texture.dispose();
			}
			if (this.width != width || this.height != height) {
				this.width = width;
				this.height = height;
				var w:Number = 2;
				while (width > w) w *= 2;
				var h:Number = 2;
				while (height > h) h *= 2;
				if (_texture) _texture.dispose();
				_texture = _context3d.createTexture(w, h, Context3DTextureFormat.BGRA, true);
			}
		}
		
		public function calculate():void {
			
		}
		
		public function dispose():void {
			if (program) program.dispose();
			if (vertexBuffer) vertexBuffer.dispose();
			if (uvBuffer) uvBuffer.dispose();
			if (indexBuffer) indexBuffer.dispose();
			if (_texture) _texture.dispose();
			_next = null;
			_context3d = null;
			vertexData = null;
			indexData = null;
			uvData = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get texture():TextureBase {
			return _texture;
		}
		
		public function get enableDepthAndStencil():Boolean {
			return false;
		}
		
		public function get next():IPostEffect {
			return _next;
		}
		
		public function set next(value:IPostEffect):void {
			_next = value;
		}
		
		public function get context3d():Context3D {
			return _context3d;
		}
		
		public function set context3d(value:Context3D):void {
			if (_context3d != value) {
				_context3d = value;
				if (program) program.dispose();
				program = context3d.createProgram();
				program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vertexShader), 
								Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader));
				if (vertexBuffer) vertexBuffer.dispose();
				vertexBuffer = context3d.createVertexBuffer(4, 3);
				vertexBuffer.uploadFromVector(vertexData, 0, 4);
				if (uvBuffer) uvBuffer.dispose();
				uvBuffer = context3d.createVertexBuffer(4, 2);
				uvBuffer.uploadFromVector(uvData, 0, 4);
				if (indexBuffer) indexBuffer.dispose();
				indexBuffer = context3d.createIndexBuffer(6);
				indexBuffer.uploadFromVector(indexData, 0, 6);
			}
		}
		
		protected function get vertexShader():String {
			return "";
		}
		
		protected function get fragmentShader():String {
			return "";
		}
		
	}

}