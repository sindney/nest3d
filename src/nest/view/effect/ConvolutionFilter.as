package nest.view.effect 
{
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	
	import nest.view.process.EffectProcess;
	import nest.view.shader.Shader3D;
	import nest.view.ViewPort;
	
	/**
	 * ConvolutionFilter
	 * <p>Just need to call comply() once.</p>
	 */
	public class ConvolutionFilter extends EffectProcess {													  
		
		public static function get EDGE():Vector.<Number> {
			return Vector.<Number>([0, 0, 1, 0, -1, 0, -1, 4, -1, 0, -1, 0]);
		}
		
		public static function get BLUR():Vector.<Number> {
			return Vector.<Number>([0, 0, 1/5, 0, 1, 0, 1, 1, 1, 0, 1, 0]);
		}
		
		public static function get SHARPEN():Vector.<Number> {
			return Vector.<Number>([0, 0, 1, 0, -1, 0, -1, 5, -1, 0, -1, 0]);
		}
		
		public static function get BEVEL():Vector.<Number> {
			return Vector.<Number>([0, 0, 1, -2, -1, 0, -1, 1, 1, 0, 1, 2]);
		}
		
		private var program:Program3D;
		
		public var kernel:Vector.<Number>;
		
		public function ConvolutionFilter(width:int = 512, height:int = 512, kernel:Vector.<Number> = null) {
			super();
			var context3d:Context3D = ViewPort.context3d;
			
			program = context3d.createProgram();
			
			if (!kernel) {
				this.kernel = Vector.<Number>([0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0]);
			} else {
				this.kernel = kernel;
			}
			
			_textures = new Vector.<TextureBase>(1, true);
			
			resize(width, height);
		}
		
		override public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			kernel[0] = 1 / ViewPort.width;
			kernel[1] = 1 / ViewPort.height;
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias, _renderTarget.surfaceSelector);
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
		
		override public function comply():void {
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
		}
		
		override public function dispose():void {
			super.dispose();
			program.dispose();
			program = null;
			kernel = null;
		}
		
	}

}