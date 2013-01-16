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
	import nest.view.process.IRenderProcess;
	
	import nest.control.factory.ShaderFactory;
	import nest.view.process.RenderProcess;
	import nest.view.ViewPort;
	
	/**
	 * Pixelation
	 */
	public class Pixelation extends RenderProcess {
		
		private var program:Program3D;
		private var vertexBuffer:VertexBuffer3D;
		private var uvBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		
		private var data:Vector.<Number>;
		
		public var pixelWidth:Number;
		public var pixelHeight:Number;
		
		public function Pixelation(width:int = 512, height:int = 512, pixelWidth:Number = 3, pixelHeight:Number = 3) {
			var context3d:Context3D = ViewPort.context3d;
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
			
			data = Vector.<Number>([0, 0, 1, 1]);
			
			_textures = new Vector.<TextureBase>(1, true);
			this.pixelWidth = pixelWidth;
			this.pixelHeight = pixelHeight;
			
			resize(_textures, width, height);
		}
		
		public function comply():void {
			var vs:String = "mov op, va0\n" + 
							"mov v0, va1\n";
			
			var fs:String = "div ft0, v0, fc0\n" + 
							"frc ft1, ft0\n" + 
							"sub ft0, ft0, ft1\n" + 
							"mul ft0, ft0, fc0\n" + 
							"tex oc, ft0, fc0 <2d, nearest, clamp, mipnone>\n";
			
			program.upload(ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
		}
		
		override public function calculate(next:IRenderProcess):void {
			var context3d:Context3D = ViewPort.context3d;
			data[0] = pixelWidth / ViewPort.width;
			data[1] = pixelHeight / ViewPort.height;
			if (next) {
				context3d.setRenderToTexture(next.texture, next.enableDepthAndStencil, next.antiAlias);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data, 1);
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
			data = null;
		}
		
	}

}