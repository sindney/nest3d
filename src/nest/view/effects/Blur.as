package nest.view.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import nest.control.GlobalMethods;
	import nest.view.Shader3D;
	
	/**
	 * Blur
	 */
	public class Blur extends PostEffect {
		
		private const _maxIteration:int = 6;
		
		private var data:Vector.<Number>;
		private var _blurX:Number;
		private var _blurY:Number;
		private var _stepX:Number;
		private var _stepY:Number;
		
		public function Blur(blurX:Number = 3, blurY:Number = 3) {
			data = Vector.<Number>([0, 0, 0, 1,0,0,0,0]);
			_blurX = blurX;
			_blurY = blurY;
			updateBlur();
			super();
		}
		
		override public function calculate():void {
			var context3d:Context3D = GlobalMethods.context3d;
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data,2);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(0, _texture);
			context3d.setProgram(program);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
		}
		
		override public function dispose():void {
			super.dispose();
			data = null;
		}
		
		private function updateBlur():void {
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
			
			var samples:int = 0;
			for (var y:Number = 0; y < _blurY; y += _stepY ) {
				for (var x:Number = 0; x < _blurX; x += _stepX ) {
					samples++;
				}
			}
			
			data[0] = _blurX * .5 * invW;
			data[1] = _blurY * .5 * invH;
			data[2] = 1 / samples;
			
			data[4] = _stepX * invW;
			data[5] = _stepY * invH;
			
			if (program) {
				program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vertexShader), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader));
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get blurX():Number {
			return _blurX;
		}
		
		public function set blurX(value:Number):void {
			_blurX = value;
			updateBlur();
		}
		
		public function get blurY():Number {
			return _blurY;
		}
		
		public function set blurY(value:Number):void {
			_blurY = value;
			updateBlur();
		}
		
		override protected function get vertexShader():String {
			return "mov op, va0\nmov v0, va1\n";
		}
		
		override protected function get fragmentShader():String {
			var code:String = "mov ft0,v0\nsub ft0.y, v0.y, fc0.y\n";
			for (var y:Number = 0; y < _blurY; y += _stepY ) {
				if (y > 0) code += "sub ft0.x, v0.x, fc0.x\n";
				for (var x:Number = 0; x < _blurX;x+=_stepX ) {
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
			return code;
		}
		
	}

}