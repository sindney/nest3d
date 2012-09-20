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
	 * CellShader
	 */
	public class CellShader extends PostEffect {
		
		private var program:Program3D;
		private var vertexBuffer:VertexBuffer3D;
		private var uvBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		
		private var data:Vector.<Number>;
		
		public function CellShader(redLevel:uint=32, greenLevel:uint=32,blueLevel:uint=32,alphaLevel:uint=32) {
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
			data = new Vector.<Number>(4,true);
			data[0] = redLevel;
			data[1] = greenLevel;
			data[2] = blueLevel;
			data[3] = alphaLevel;
			
			_textures = new Vector.<TextureBase>(1, true);
			
			AGAL.clear();
			AGAL.mov(AGAL.OP, AGAL.POS_ATTRIBUTE);
			AGAL.mov("v0", AGAL.UV_ATTRIBUTE);
			var vertexShader:String = AGAL.code;
			
			AGAL.clear();
			AGAL.tex("ft0", "v0", "fs0");
			AGAL.mul("ft0", "ft0", "fc0");
			AGAL.frc("ft1", "ft0");
			AGAL.sub("ft0", "ft0", "ft1");
			AGAL.div(AGAL.OC, "ft0", "fc0");
			var fragmentShader:String = AGAL.code;
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vertexShader), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader));
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
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get redLevel():uint {
			return data[0];
		}
		
		public function set redLevel(value:uint):void {
			data[0] = value;
		}
		
		public function get greenLevel():uint {
			return data[1];
		}
		
		public function set greenLevel(value:uint):void {
			data[1] = value;
		}
		
		public function get blueLevel():uint {
			return data[2];
		}
		
		public function set blueLevel(value:uint):void {
			data[2] = value;
		}
		
		public function get alphaLevel():uint {
			return data[3];
		}
		
		public function set alphaLevel(value:uint):void {
			data[3] = value;
		}
		
	}

}