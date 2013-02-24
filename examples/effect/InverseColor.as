package effect 
{
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	
	import nest.view.process.IRenderProcess;
	import nest.view.process.RenderTarget;
	import nest.view.shader.Shader3D;
	import nest.view.ViewPort;
	
	/**
	 * InverseColor
	 * <p>Just need to call comply() once.</p>
	 */
	public class InverseColor implements IRenderProcess {
		
		private var _renderTarget:RenderTarget = new RenderTarget();
		
		private var program:Program3D;
		
		private var data:Vector.<Number>;
		
		public var texture0:TextureBase;
		
		public function InverseColor(width:int = 512, height:int = 512) {
			var context3d:Context3D = ViewPort.context3d;
			
			program = context3d.createProgram();
			
			data = Vector.<Number>([1, 1, 1, 1]);
			
			texture0 = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, true);
		}
		
		public function calculate():void {
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
			context3d.setTextureAt(0, texture0);
			context3d.setProgram(program);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
		}
		
		public function comply():void {
			var vs:String = "mov op, va0\n" + 
							"mov v0, va1\n";
			
			var fs:String = "tex ft0, v0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"sub oc, fc0.rgb, ft0.rgb\n";
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
		}
		
		public function dispose():void {
			program.dispose();
			program = null;
			data = null;
			_renderTarget = null;
			if (texture0) texture0.dispose();
			texture0 = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get renderTarget():RenderTarget {
			return _renderTarget;
		}
	}

}