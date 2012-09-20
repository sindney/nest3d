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
	import nest.control.factory.AGAL;
	
	import nest.control.EngineBase;
	import nest.view.Shader3D;
	
	/**
	 * RadialBlur
	 */
	public class RadialBlur extends PostEffect {
		
		private var program:Program3D;
		private var vertexBuffer:VertexBuffer3D;
		private var uvBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		
		private var data:Vector.<Number>;
		
		public function RadialBlur(strength:Number = 1, iteration:int = 20,centerX:Number=400,centerY:Number=300) {
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
			
			data = Vector.<Number>([strength/100, 1/iteration,centerX/ EngineBase.view.width, centerY/ EngineBase.view.height]);
			
			update();
			
			_textures = new Vector.<TextureBase>(1, true);
			super();
		}
		
		override public function calculate():void {
			var context3d:Context3D = EngineBase.context3d;
			if (_next) {
				context3d.setRenderToTexture(_next.textures[0], _next.enableDepthAndStencil, _next.antiAlias);
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
		
		public function update():void {
			var j:uint = iteration;
			
			AGAL.clear();
			AGAL.mov(AGAL.OP, AGAL.POS_ATTRIBUTE);
			AGAL.mov("v0", AGAL.UV_ATTRIBUTE);
			var vertexShader:String = AGAL.code;
			
			AGAL.clear();
			AGAL.mov("ft0", "v0");
			AGAL.tex("ft3", "ft0", "fs0");
			for (var i:int = 1; i < j;i++ ) {
				AGAL.sub("ft1.xy", "fc0.zw", "ft0.xy");
				AGAL.mul("ft1.xy", "ft1.xy", "fc0.xx");
				AGAL.sub("ft0.xy", "ft0.xy", "ft1.xy");
				AGAL.tex("ft2", "ft0", "fs0");
				AGAL.add("ft3", "ft3", "ft2");
			}
			AGAL.mul(AGAL.OC, "ft3", "fc0.y");
			var fragmentShader:String = AGAL.code;
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, "mov op, va0\nmov v0, va1\n"), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get strength():Number {
			return data[0]*100;
		}
		
		public function set strength(value:Number):void {
			data[0] = value/100;
		}
		
		public function get iteration():int {
			return 1/data[1];
		}
		
		public function set iteration(value:int):void {
			data[1] = 1 / value;
			update();
		}
		
		public function get centerX():Number {
			return data[3]*EngineBase.view.width;
		}
		
		public function set centerX(value:Number):void {
			data[3] = value/EngineBase.view.width;
		}
		
		public function get centerY():Number {
			return data[4]*EngineBase.view.height;
		}
		
		public function set centerY(value:Number):void {
			data[4] = value/EngineBase.view.height;
		}
		
	}

}