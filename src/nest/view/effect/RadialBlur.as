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
	 * RadialBlur
	 * <p>comply() after iteration is changed.</p>
	 */
	public class RadialBlur extends EffectProcess {
		
		private var program:Program3D;
		
		private var data:Vector.<Number>;
		
		public function RadialBlur(width:int = 512, height:int = 512, strength:Number = 1, iteration:int = 20, centerX:Number = 400, centerY:Number = 300) {
			super();
			var context3d:Context3D = ViewPort.context3d;
			
			program = context3d.createProgram();
			
			data = Vector.<Number>([strength / 100, 0, centerX / ViewPort.width, centerY / ViewPort.height]);
			
			this.iteration = iteration;
			
			_textures = new Vector.<TextureBase>(1, true);
			resize(width, height);
		}
		
		override public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias);
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
		
		override public function comply():void {
			var vs:String = "mov op, va0\n" + 
							"mov v0, va1\n";
			
			var fs:String = "mov ft0, v0\n" + 
							"tex ft3, ft0, fs0 <2d, nearest, clamp, mipnone>\n";
			
			for (var i:int = 1; i < iteration; i++) {
				fs += "sub ft1.xy, fc0.zw, ft0.xy\n" + 
					"mul ft1.xy, ft1.xy, fc0.xx\n" + 
					"sub ft0.xy, ft0.xy, ft1.xy\n" + 
					"tex ft2, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
					"add ft3, ft3, ft2\n";
			}
			fs += "mul oc, ft3, fc0.y\n";
			
			program.upload(ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
		}
		
		override public function dispose():void {
			super.dispose();
			program.dispose();
			program = null;
			data = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get strength():Number {
			return data[0] * 100;
		}
		
		public function set strength(value:Number):void {
			data[0] = value / 100;
		}
		
		public function get iteration():int {
			return 1 / data[1];
		}
		
		public function set iteration(value:int):void {
			data[1] = 1 / value;
		}
		
		public function get centerX():Number {
			return data[3] * ViewPort.width;
		}
		
		public function set centerX(value:Number):void {
			data[3] = value / ViewPort.width;
		}
		
		public function get centerY():Number {
			return data[4] * ViewPort.height;
		}
		
		public function set centerY(value:Number):void {
			data[4] = value / ViewPort.height;
		}
		
	}

}