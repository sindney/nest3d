package nest.view.effect 
{
	
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	
	import nest.control.EngineBase;
	import nest.view.Shader3D;
	
	/**
	 * ConvolutionFilter
	 */
	public class ConvolutionFilter extends PostEffect {													  
		
		public static function get EDGE():Vector.<Number> {
			return Vector.<Number>([1 / EngineBase.view.width, 1 / EngineBase.view.height, 1, 
																  0, -1, 0, 
																  -1, 4, -1,
																  0, -1, 0]);
		}
		
		public static function get BLUR():Vector.<Number> {
			return Vector.<Number>([1 / EngineBase.view.width, 1 / EngineBase.view.height, 1/5, 
																  0, 1, 0, 
																  1, 1, 1,
																  0, 1, 0]);
		}
		
		public static function get SHARPEN():Vector.<Number> {
			return Vector.<Number>([1 / EngineBase.view.width, 1 / EngineBase.view.height, 1, 
																  0, -1, 0, 
																  -1, 5, -1,
																  0, -1, 0]);
		}
		
		public static function get BEVEL():Vector.<Number> {
			return Vector.<Number>([1 / EngineBase.view.width, 1 / EngineBase.view.height, 1, 
																  -2, -1, 0, 
																  -1, 1, 1,
																  0, 1, 2]);
		}
		
		private var program:Program3D;
		private var vertexBuffer:VertexBuffer3D;
		private var uvBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		
		private var _kernel:Vector.<Number>;
		
		/**
		 * Change kernel[0] to (1 / view width) and kernel[1] to (1 / view height) when view is resized.
		 * @param	kernel
		 */
		public function ConvolutionFilter(width:int = 512, height:int = 512, kernel:Vector.<Number> = null) {
			var context3d:Context3D = EngineBase.context3d;
			var vertexData:Vector.<Number> = Vector.<Number>([-1, 1, 0, -1, -1, 0, 1, -1, 0, 1, 1, 0]);
			var uvData:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 0]);
			var indexData:Vector.<uint> = Vector.<uint>([0, 3, 2, 2, 1, 0]);
			program = context3d.createProgram();
			vertexBuffer = context3d.createVertexBuffer(4, 3);
			vertexBuffer.uploadFromVector(vertexData, 0, 4);
			uvBuffer = context3d.createVertexBuffer(4, 2);
			uvBuffer.uploadFromVector(uvData, 0, 4);
			indexBuffer = context3d.createIndexBuffer(6);
			indexBuffer.uploadFromVector(indexData, 0, 6);
			
			if (kernel) {
				_kernel = kernel;
			} else {
				_kernel = Vector.<Number>([1 / EngineBase.view.width, 1 / EngineBase.view.height, 1, 
										  0, 0, 0, 
										  0, 1, 0,
										  0, 0, 0]);
			}
			_textures = new Vector.<TextureBase>(1, true);
			
			var vs:String = "mov op, va0\n" + 
							"mov v0, va1\n";
			
			var fs:String = "mov ft0, v0\n" + 
							"sub ft0.xy, v0.xy, fc0.xy\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft2, ft1, fc0.w\n" + 
							"add ft0.x, ft0.x, fc0.x\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft1, ft1, fc1.x\n" + 
							"add ft2, ft2, ft1\n" + 
							"add ft0.x, ft0.x, fc0.x\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft1, ft1, fc1.y\n" + 
							"add ft2, ft2, ft1\n" + 
							"sub ft0.x, v0.x, fc0.x\n" + 
							"add ft0.y, ft0.y, fc0.y\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft1, ft1, fc1.z\n" + 
							"add ft2, ft2, ft1\n" + 
							"add ft0.x, ft0.x, fc0.x\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft1, ft1, fc1.w\n" + 
							"add ft2, ft2, ft1\n" + 
							"add ft0.x, ft0.x, fc0.x\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft1, ft1, fc2.x\n" + 
							"add ft2, ft2, ft1\n" + 
							"sub ft0.x, v0.x, fc0.x\n" + 
							"add ft0.y, ft0.y, fc0.y\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft1, ft1, fc2.y\n" + 
							"add ft2, ft2, ft1\n" + 
							"add ft0.x, ft0.x, fc0.x\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft1, ft1, fc2.z\n" + 
							"add ft2, ft2, ft1\n" + 
							"add ft0.x, ft0.x, fc0.x\n" + 
							"tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft1, ft1, fc2.w\n" + 
							"add ft2, ft2, ft1\n" + 
							"mul oc, ft2, fc0.z\n";
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
			resize(_textures, width, height);
		}
		
		override public function calculate(next:IPostEffect):void {
			var context3d:Context3D = EngineBase.context3d;
			if (next) {
				context3d.setRenderToTexture(next.textures[0], next.enableDepthAndStencil, next.antiAlias);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, kernel, 3);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(0, _textures[0]);
			context3d.setProgram(program);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
		}
		
		override public function dispose():void {
			super.dispose();
			vertexBuffer.dispose();
			uvBuffer.dispose();
			indexBuffer.dispose();
			program.dispose();
			_kernel = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get kernel():Vector.<Number> {
			return _kernel;
		}
		
		public function set kernel(value:Vector.<Number>):void {
			_kernel = value;
		}
		
	}

}