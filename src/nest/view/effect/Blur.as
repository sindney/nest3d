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
	
	import nest.control.EngineBase;
	import nest.view.Shader3D;
	
	/**
	 * Blur
	 */
	public class Blur extends PostEffect {
		
		private var program:Program3D;
		private var vertexBuffer:VertexBuffer3D;
		private var uvBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		
		private var data:Vector.<Number>;
		private var stepX:Number;
		private var stepY:Number;
		
		private var _maxIteration:int = 6;
		private var _blurX:Number;
		private var _blurY:Number;
		
		public function Blur(width:int = 512, height:Number = 512, blurX:Number = 3, blurY:Number = 3) {
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
			data = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 0]);
			
			_textures = new Vector.<TextureBase>(1, true);
			_blurX = blurX;
			_blurY = blurY;
			update();
			resize(_textures, width, height);
		}
		
		override public function calculate(next:IPostEffect):void {
			var context3d:Context3D = EngineBase.context3d;
			if (next) {
				context3d.setRenderToTexture(next.textures[0], next.enableDepthAndStencil, next.antiAlias);
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
		
		override public function dispose():void {
			super.dispose();
			vertexBuffer.dispose();
			uvBuffer.dispose();
			indexBuffer.dispose();
			program.dispose();
			data = null;
		}
		
		private function update():void {
			var invW:Number = 1 / EngineBase.view.width;
			var invH:Number = 1 / EngineBase.view.height;
			
			if (_blurX > _maxIteration) {
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
			
			var vs:String = "mov op, va0\n" + 
							"mov v0, va1\n";
			
			var fs:String = "mov ft0, v0\n" + 
							"sub ft0.y, v0.y, fc0.y\n";
			for (y = 0; y < _blurY; y += stepY) {
				if (y > 0) fs += "sub ft0.x, v0.x, fc0.x\n";
				for (x = 0; x < _blurX; x += stepX) {
					if (x == 0 && y == 0) {
						fs += "tex ft1, ft0, fs0 <2d, nearest, clamp, mipnone>\n";
					} else {
						fs += "tex ft2, ft0, fs0 <2d, nearest, clamp, mipnone>\n" + 
								"add ft1, ft1, ft2\n";
					}
					if (x < _blurX) fs += "add ft0.x, ft0.x, fc1.x\n";
				}
				if (y < _blurY) fs += "add ft0.y, ft0.y, fc1.y\n";
			}
			fs += "mul oc, ft1, fc0.z\n";
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
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
		
		public function get maxIteration():int {
			return _maxIteration;
		}
		
		public function set maxIteration(value:int):void {
			_maxIteration = value;
			update();
		}
		
	}

}