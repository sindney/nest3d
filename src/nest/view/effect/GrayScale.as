package nest.view.effect 
{
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	
	import nest.control.factory.ShaderFactory;
	import nest.view.process.EffectProcess;
	import nest.view.ViewPort;
	
	/**
	 * GrayScale
	 */
	public class GrayScale extends EffectProcess {
		
		private var program:Program3D;
		
		private var data:Vector.<Number>;
		
		public function GrayScale(width:int = 512, height:int = 512) {
			super();
			var context3d:Context3D = ViewPort.context3d;
			
			program = context3d.createProgram();
			
			data = Vector.<Number>([0.229, 0.587, 0.114, 1]);
			
			_textures = new Vector.<TextureBase>(1, true);
			resize(width, height);
		}
		
		override public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias, _renderTarget.surfaceSelector);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data);
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
			
			var fs:String = "tex ft0, v0, fs0 <2d, linear, clamp, mipnone>\n" + 
							"dp3 ft1, ft0.rgb, fc0.rgb\n" + 
							"mov oc, ft1\n";
							
			program.upload(ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
		}
		
		override public function dispose():void {
			super.dispose();
			program.dispose();
			program = null;
			data = null;
		}
		
	}

}