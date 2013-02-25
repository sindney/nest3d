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
	 * Bloom
	 * <p>Call comply() when threshold/maxIteration/blurX/blurY is changed.</p>
	 */
	public class Bloom extends PostEffect {
		
		private var program1:Program3D;
		private var program2:Program3D;
		
		private var data:Vector.<Number>;
		private var thresholds:Vector.<Number>;
		
		public var texture0:TextureBase;
		public var texture1:TextureBase;
		
		public var maxIteration:int = 6;
		public var blurX:Number;
		public var blurY:Number;
		
		public function Bloom(width:int = 512, height:int = 512, blurX:Number = 4, blurY:Number = 4, threshold:Number = 0.75) {
			super();
			var context3d:Context3D = ViewPort.context3d;
			
			program1 = context3d.createProgram();
			program2 = context3d.createProgram();
			
			data = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 0]);
			
			thresholds = Vector.<Number>([threshold, threshold, threshold, threshold]);
			
			this.blurX = blurX;
			this.blurY = blurY;
			
			texture0 = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, true);
			texture1 = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, true);
			
			comply();
		}
		
		override public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			context3d.setRenderToTexture(texture1);
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, thresholds);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(0, texture0);
			context3d.setProgram(program2);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
			context3d.setTextureAt(1, null);
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias, _renderTarget.surfaceSelector);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data, 2);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(1, texture0);
			context3d.setTextureAt(0, texture1);
			context3d.setProgram(program1);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
			context3d.setTextureAt(1, null);
		}
		
		public function comply():void {
			var invW:Number = 1 / 512;
			var invH:Number = 1 / 512;
			
			var stepX:Number, stepY:Number;
			
			if (blurX> maxIteration) {
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
			
			var vs:String = "mov op va0\nmov v0, va1\n";
			
			var fs1:String = "mov ft0, v0\n" +
							"sub ft0.y, v0.y, fc0.y\n";
			
			for (y = 0; y < blurY; y += stepY) {
				if (y > 0) fs1 += "sub ft0.x, v0.x, fc0.x\n";
				for (x = 0; x < blurX; x += stepX) {
					if (x == 0 && y == 0){
						fs1 += "tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n";
					} else {
						fs1 += "tex ft2, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
								"add ft1, ft1, ft2\n";
					}
					if (x < blurX)
						fs1 += "add ft0.x, ft0.x, fc1.x\n";
				}
				if (y < blurY) fs1 += "add ft0.y, ft0.y, fc1.y\n";
			}
			fs1 += "mul ft0, ft1, fc0.z\n" + 
					"tex ft1, v0, fs1 <2d, nearest, clamp, mipnone>\n" + 
					"sat ft1, ft1\n" + 
					"add oc, ft0, ft1\n";
					
			var fs2:String = "tex ft0, v0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"sge ft1, ft0, fc0\n" + 
							"mul oc, ft0, ft1\n";
			
			program1.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fs1));
							
			program2.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fs2));
		}
		
		override public function dispose():void {
			super.dispose();
			program1.dispose();
			program2.dispose();
			data = null;
			thresholds = null;
			if (texture0) texture0.dispose();
			texture0 = null;
			if (texture1) texture1.dispose();
			texture1 = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get threshold():Number {
			return thresholds[0];
		}
		
		public function set threshold(value:Number):void {
			thresholds[0] = value;
			thresholds[1] = value;
			thresholds[2] = value;
			thresholds[3] = value;
		}
		
		override public function get texture():TextureBase {
			return texture0;
		}
		
	}

}