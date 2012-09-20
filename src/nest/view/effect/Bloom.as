package nest.view.effect 
{
	import flash.display3D.textures.Texture;
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
	 * Bloom
	 */
	public class Bloom extends PostEffect {
		
		private var program1:Program3D;
		private var program2:Program3D;
		private var vertexBuffer:VertexBuffer3D;
		private var uvBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		
		private var data:Vector.<Number>;
		private var thresholds:Vector.<Number>;
		
		private var stepX:Number;
		private var stepY:Number;
		
		private var _maxIteration:int = 6;
		private var _blurX:Number;
		private var _blurY:Number;
		
		public function Bloom(blurX:Number = 4, blurY:Number = 4, threshold:Number = 0.75) {
			var context3d:Context3D = EngineBase.context3d;
			var vertexData:Vector.<Number> = Vector.<Number>([-1, 1, 0, -1, -1, 0, 1, -1, 0, 1, 1, 0]);
			var uvData:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 0]);
			var indexData:Vector.<uint> = Vector.<uint>([0, 3, 2, 2, 1, 0]);
			program1 = context3d.createProgram();
			program2 = context3d.createProgram();
			vertexBuffer = context3d.createVertexBuffer(4, 3);
			vertexBuffer.uploadFromVector(vertexData, 0, 4);
			uvBuffer = context3d.createVertexBuffer(4, 2);
			uvBuffer.uploadFromVector(uvData, 0, 4);
			indexBuffer = context3d.createIndexBuffer(6);
			indexBuffer.uploadFromVector(indexData, 0, 6);
			data = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 0]);
			
			_textures = new Vector.<TextureBase>(2, true);
			_blurX = blurX;
			_blurY = blurY;
			thresholds = Vector.<Number>([threshold, threshold, threshold, threshold]);
			update();
			super();
		}
		
		override public function calculate():void {
			var context3d:Context3D = EngineBase.context3d;
			context3d.setRenderToTexture(_textures[1]);
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, thresholds);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(0, _textures[0]);
			context3d.setProgram(program2);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
			context3d.setTextureAt(1, null);
			if (_next) {
				context3d.setRenderToTexture(_next.textures[0], _next.enableDepthAndStencil, _next.antiAlias);
			}else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data, 2);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(1, _textures[0]);
			context3d.setTextureAt(0, _textures[1]);
			context3d.setProgram(program1);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
			context3d.setTextureAt(1, null);
		}
		
		override public function dispose():void {
			super.dispose();
			vertexBuffer.dispose();
			uvBuffer.dispose();
			indexBuffer.dispose();
			program1.dispose();
			program2.dispose();
			data = null;
		}
		
		private function update():void {
			var invW:Number = 1 / 512;
			var invH:Number = 1 / 512;
			
			if (_blurX> _maxIteration) {
				stepX = _blurX / _maxIteration;
			}else {
				stepX = 1;
			}
			
			if (_blurY > _maxIteration) {
				stepY = _blurY / _maxIteration;
			}else {
				stepY = 1;
			}
			
			var x:Number;
			var y:Number;
			var samples:int = 0;
			for (y = 0; y < _blurY; y += stepY ) {
				for (x = 0; x < _blurX; x += stepX ) {
					samples++;
				}
			}
			
			data[0] = _blurX * .5 * invW;
			data[1] = _blurY * .5 * invH;
			data[2] = 1 / samples;
			
			data[4] = stepX * invW;
			data[5] = stepY * invH;
			
			AGAL.clear();
			AGAL.mov(AGAL.OP, AGAL.POS_ATTRIBUTE);
			AGAL.mov("v0", AGAL.UV_ATTRIBUTE);
			var vertexShader:String = AGAL.code;
			
			AGAL.clear();
			AGAL.mov("ft0", "v0");
			AGAL.sub("ft0.y", "v0.y", "fc0.y");
			for (y = 0; y < _blurY; y += stepY) {
				if (y > 0) AGAL.sub("ft0.x", "v0.x", "fc0.x");
				for (x = 0; x < _blurX; x += stepX) {
					if (x == 0 && y == 0){
						AGAL.tex("ft1", "ft0", "fs0");
					}else {
						AGAL.tex("ft2", "ft0", "fs0");
						AGAL.add("ft1", "ft1", "ft2");
					}
					if (x < _blurX)
						AGAL.add("ft0.x", "ft0.x", "fc1.x");
				}
				if (y < _blurY) AGAL.add("ft0.y", "ft0.y", "fc1.y");
			}
			AGAL.mul("ft0", "ft1", "fc0.z");
			AGAL.tex("ft1", "v0", "fs1");
			AGAL.sat("ft1", "ft1");
			AGAL.add(AGAL.OC, "ft0", "ft1");
			var fragmentShader1:String = AGAL.code;
			
			AGAL.clear();
			AGAL.tex("ft0", "v0", "fs0", AGAL.TYPE_2D, AGAL.FILTER_NEAREST, AGAL.WRAP_CLAMP);
			AGAL.sge("ft1", "ft0", "fc0");
			AGAL.mul(AGAL.OC, "ft0", "ft1");
			var fragmentShader2:String = AGAL.code;
			
			program1.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vertexShader), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader1));
							
			program2.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vertexShader), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader2));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get maxIteration():int {
			return _maxIteration;
		}
		
		public function set maxIteration(value:int):void {
			_maxIteration = value;
			update();
		}
		
		public function get blurX():Number {
			return _blurX;
		}
		
		public function set blurX(value:Number):void {
			_blurX = value;
			update();
		}
		
		public function get blurY():Number {
			return _blurY;
		}
		
		public function set blurY(value:Number):void {
			_blurY = value;
			update();
		}
		
		public function get threshold():Number {
			return thresholds[0];
		}
		
		public function set threshold(value:Number):void {
			thresholds[0] = value;
			thresholds[1] = value;
			thresholds[2] = value;
			thresholds[3] = value;
		}
	}

}