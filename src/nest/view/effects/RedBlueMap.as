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
	import flash.geom.Vector3D;
	import nest.view.managers.ISceneManager;
	
	import nest.control.EngineBase;
	import nest.view.Shader3D;
	
	/**
	 * RedBlueMap
	 */
	public class RedBlueMap extends PostEffect {
		
		private var program:Program3D;
		private var vertexBuffer:VertexBuffer3D;
		private var uvBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		
		private var data:Vector.<Number>;
		
		private var _eyePadding:Number;
		
		public function RedBlueMap(eyePadding:Number = 1) {
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
			data = Vector.<Number>([1, 0, 0, 1, 0, 1, 1, 1]);
			
			_textures = new Vector.<TextureBase>(2, true);
			
			_eyePadding = eyePadding;
			var code:String = "tex ft0, v0, fs0 <2d,nearest,clamp>\n"
							 +"tex ft1, v0, fs1 <2d,nearest,clamp>\n"
							 +"mul ft2,ft0,fc0\n"
							 +"mul ft3,ft1,fc1\n"
							 +"add oc,ft2,ft3";
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, "mov op, va0\nmov v0, va1\n"), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, code));
			super();
		}
		
		override public function calculate():void {
			var context3d:Context3D = EngineBase.context3d;
			context3d.setRenderToTexture(_textures[1], enableDepthAndStencil, antiAlias);
			context3d.clear();
			EngineBase.camera.translate(Vector3D.X_AXIS, _eyePadding);
			EngineBase.camera.recompose();
			var _camPos:Vector.<Number> = new Vector.<Number>(4, true);
			_camPos[0] = EngineBase.camera.position.x;
			_camPos[1] = EngineBase.camera.position.y;
			_camPos[2] = EngineBase.camera.position.z;
			_camPos[3] = 1;
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, _camPos);
			
			EngineBase.manager.first = true;
			EngineBase.manager.culling = EngineBase.view.culling;
			EngineBase.manager.process = EngineBase.view.process;
			EngineBase.manager.calculate();
			
			EngineBase.camera.translate(Vector3D.X_AXIS, -_eyePadding);
			EngineBase.camera.recompose();
			
			if (_next) {
				context3d.setRenderToTexture(_next.textures[0], _next.enableDepthAndStencil, _next.antiAlias);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data,2);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(0, _textures[0]);
			context3d.setTextureAt(1, _textures[1]);
			context3d.setProgram(program);
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
			program.dispose();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get eyePadding():Number {
			return _eyePadding;
		}
		
		public function set eyePadding(value:Number):void {
			_eyePadding = value;
		}
		
	}

}