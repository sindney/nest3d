package nest.view.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import nest.control.GlobalMethods;
	
	/**
	 * Gray
	 */
	public class InverseColor extends PostEffect {
		
		private var data:Vector.<Number>;
		
		public function InverseColor() {
			super();
			data = Vector.<Number>([1, 1, 1, 1]);
		}
		
		override public function calculate():void {
			var context3d:Context3D = GlobalMethods.context3d;
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(0, _texture);
			context3d.setProgram(program);
			context3d.drawTriangles(indexBuffer);
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
			return "tex ft0, v0, fs0 <2d,linear,mipnone>\nsub oc.rgb,fc0.rgb,ft0.rgb";
		}
		
	}

}