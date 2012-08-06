package nest.view.effects 
{
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	
	/**
	 * NightVision
	 */
	public class NightVision extends PostEffect {
		
		private var data:Vector.<Number>;
		
		public function NightVision() {
			super();
			data = Vector.<Number>([0, 1, 0, 1]);
		}
		
		override public function calculate():void {
			_context3d.clear();
			_context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data);
			_context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3d.setTextureAt(0, _texture);
			_context3d.setProgram(program);
			_context3d.drawTriangles(indexBuffer);
		}
		
		override public function dispose():void {
			super.dispose();
			data = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		override protected function get vertexShader():String {
			return "mov op, va0\nmov v0, va1\n";
		}
		
		override protected function get fragmentShader():String {
			return "tex ft0, v0, fs0 <2d,linear,mipnone>\nmul oc, ft0.rgb, fc0.rgb\n";
		}
		
	}

}