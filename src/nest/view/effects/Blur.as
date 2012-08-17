package nest.view.effects 
{
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	
	import nest.control.GlobalMethods;
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
		
		private var _maxIteration:int = 6;
		private var _blurX:Number;
		private var _blurY:Number;
		private var _stepX:Number;
		private var _stepY:Number;
		
		public function Blur(blurX:Number = 4, blurY:Number = 4) {
			var context3d:Context3D = GlobalMethods.context3d;
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
			super();
		}
		
		override public function calculate():void {
			var context3d:Context3D = GlobalMethods.context3d;
			if (_next) {
				context3d.setRenderToTexture(_next.textures[0], _next.enableDepthAndStencil, _next.antiAlias);
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
			data = null;
		}
		
		private function update():void {
			var invW:Number = 1 / 512;
			var invH:Number = 1 / 512;
			
			if (_blurX> _maxIteration) {
				_stepX = _blurX / _maxIteration;
			}else {
				_stepX = 1;
			}
			
			if (_blurY > _maxIteration) {
				_stepY = _blurY / _maxIteration;
			}else {
				_stepY = 1;
			}
			
			var x:Number;
			var y:Number;
			var samples:int = 0;
			for (y = 0; y < _blurY; y += _stepY ) {
				for (x = 0; x < _blurX; x += _stepX ) {
					samples++;
				}
			}
			
			data[0] = _blurX * .5 * invW;
			data[1] = _blurY * .5 * invH;
			data[2] = 1 / samples;
			
			data[4] = _stepX * invW;
			data[5] = _stepY * invH;
			
			var code:String = "mov ft0,v0\nsub ft0.y, v0.y, fc0.y\n";
			for (y = 0; y < _blurY; y += _stepY) {
				if (y > 0) code += "sub ft0.x, v0.x, fc0.x\n";
				for (x = 0; x < _blurX; x += _stepX) {
					if (x == 0 && y == 0)
						code += "tex ft1, ft0, fs0 <2d,nearest,clamp>\n";
					else
						code += "tex ft2, ft0, fs0 <2d,nearest,clamp>\n" +
								"add ft1, ft1, ft2 \n";
					if (x < _blurX)
						code += "add ft0.x, ft0.x, fc1.x\n";
				}
				if (y < _blurY) code += "add ft0.y, ft0.y, fc1.y\n";
			}
			code += "mul oc, ft1, fc0.z";
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, "mov op, va0\nmov v0, va1\n"), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, code));
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
		
		public function get stepX():Number {
			return _stepX;
		}
		
		public function set stepX(value:Number):void {
			_stepX = value;
			update();
		}
		
		public function get stepY():Number {
			return _stepY;
		}
		
		public function set stepY(value:Number):void {
			_stepY = value;
			update();
		}
		
	}

}