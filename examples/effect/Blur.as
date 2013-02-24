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
	 * Blur
	 * <p>Call comply() when maxIteration/blurX/blurY is changed.</p>
	 */
	public class Blur implements IRenderProcess {
		
		private var _renderTarget:RenderTarget = new RenderTarget();
		
		private var program:Program3D;
		
		private var data:Vector.<Number>;
		
		public var texture0:TextureBase;
		
		public var maxIteration:int = 6;
		public var blurX:Number;
		public var blurY:Number;
		
		public function Blur(width:int = 512, height:Number = 512, blurX:Number = 3, blurY:Number = 3) {
			var context3d:Context3D = ViewPort.context3d;
			
			program = context3d.createProgram();
			
			data = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 0]);
			
			this.blurX = blurX;
			this.blurY = blurY;
			
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
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data, 2);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(0, _textures[0]);
			context3d.setProgram(program);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
		}
		
		public function comply():void {
			var invW:Number = 1 / ViewPort.width;
			var invH:Number = 1 / ViewPort.height;
			
			var stepX:Number, stepY:Number;
			
			if (blurX > maxIteration) {
				stepX = blurX / maxIteration;
			}else {
				stepX = 1;
			}
			
			if (blurY > maxIteration) {
				stepY = blurY / maxIteration;
			}else {
				stepY = 1;
			}
			
			var x:Number;
			var y:Number;
			var samples:int = 0;
			for (y = 0; y < blurY; y += stepY ) {
				for (x = 0; x < blurX; x += stepX ) {
					samples++;
				}
			}
			
			data[0] = blurX * .5 * invW;
			data[1] = blurY * .5 * invH;
			data[2] = 1 / samples;
			
			data[4] = stepX * invW;
			data[5] = stepY * invH;
			
			var vs:String = "mov op, va0\n" + 
							"mov v0, va1\n";
			
			var fs:String = "mov ft0, v0\n" + 
							"sub ft0.y, v0.y, fc0.y\n";
			for (y = 0; y < blurY; y += stepY) {
				if (y > 0) fs += "sub ft0.x, v0.x, fc0.x\n";
				for (x = 0; x < blurX; x += stepX) {
					if (x == 0 && y == 0) {
						fs += "tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n";
					} else {
						fs += "tex ft2, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
								"add ft1, ft1, ft2\n";
					}
					if (x < blurX) fs += "add ft0.x, ft0.x, fc1.x\n";
				}
				if (y < blurY) fs += "add ft0.y, ft0.y, fc1.y\n";
			}
			fs += "mul oc, ft1, fc0.z\n";
			
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