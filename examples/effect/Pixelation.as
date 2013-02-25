package effect 
{
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	
	import nest.view.shader.Shader3D;
	import nest.view.ViewPort;
	
	/**
	 * Pixelation
	 * <p>Just need to call comply() once.</p>
	 */
	public class Pixelation extends PostEffect {
		
		private var program:Program3D;
		
		private var data:Vector.<Number>;
		
		public var texture0:TextureBase;
		
		public var pixelWidth:Number;
		public var pixelHeight:Number;
		
		public function Pixelation(width:int = 512, height:int = 512, pixelWidth:Number = 3, pixelHeight:Number = 3) {
			super();
			var context3d:Context3D = ViewPort.context3d;
			
			program = context3d.createProgram();
			
			data = Vector.<Number>([0, 0, 1, 1]);
			
			this.pixelWidth = pixelWidth;
			this.pixelHeight = pixelHeight;
			
			texture0 = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, true);
			
			comply();
		}
		
		override public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			data[0] = pixelWidth / ViewPort.width;
			data[1] = pixelHeight / ViewPort.height;
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias, _renderTarget.surfaceSelector);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data, 1);
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
			
			var fs:String = "div ft0, v0, fc0\n" + 
							"frc ft1, ft0\n" + 
							"sub ft0, ft0, ft1\n" + 
							"mul ft0, ft0, fc0\n" + 
							"tex oc, ft0, fc0 <2d, nearest, clamp, mipnone>\n";
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
		}
		
		override public function dispose():void {
			super.dispose();
			program.dispose();
			program = null;
			data = null;
			if (texture0) texture0.dispose();
			texture0 = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		override public function get texture():TextureBase {
			return texture0;
		}
		
	}

}