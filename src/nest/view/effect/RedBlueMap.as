package nest.view.effect 
{
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.geom.Vector3D;
	
	import nest.control.factory.ShaderFactory;
	import nest.object.IMesh;
	import nest.view.process.ContainerProcess;
	import nest.view.process.EffectProcess;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * RedBlueMap
	 */
	public class RedBlueMap extends EffectProcess {
		
		private var program:Program3D;
		
		private var data:Vector.<Number>;
		
		public var containerProcess:ContainerProcess;
		public var eyePadding:Number;
		
		public function RedBlueMap(width:int = 512, height:int = 512, containerProcess:ContainerProcess = null, eyePadding:Number = 1) {
			super();
			var context3d:Context3D = ViewPort.context3d;
			
			program = context3d.createProgram();
			
			data = Vector.<Number>([1, 0, 0, 1, 0, 1, 1, 1]);
			
			this.containerProcess = containerProcess;
			this.eyePadding = eyePadding;
			
			_textures = new Vector.<TextureBase>(2, true);
			resize(width, height);
		}
		
		override public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			var camera:Camera3D = containerProcess.camera;
			
			context3d.setRenderToTexture(_textures[1], _enableDepthAndStencil, _antiAlias);
			context3d.clear();
			
			var p:Vector3D = new Vector3D(1, 0, 0);
			p.scaleBy(eyePadding);
			camera.position.copyFrom(camera.matrix.transformVector(p));
			camera.recompose();
			
			var _camPos:Vector.<Number> = new Vector.<Number>(4, true);
			_camPos[0] = p.x;
			_camPos[1] = p.y;
			_camPos[2] = p.z;
			_camPos[3] = 1;
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, _camPos);
			
			var object:IMesh;
			for each(object in containerProcess.objects) {
				containerProcess.meshProcess.calculate(object, camera.invertMatrix, camera.pm);
			}
			
			p.setTo(1, 0, 0);
			p.scaleBy( -eyePadding);
			camera.position.copyFrom(camera.matrix.transformVector(p));
			camera.recompose();
			
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias);
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
		
		override public function comply():void {
			var vs:String = "mov op, va0\n" + 
							"mov v0, va1\n";
			
			var fs:String = "tex ft0, v0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"tex ft1, v0, fs1 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft2, ft0, fc0\n" + 
							"mul ft3, ft1, fc1\n" + 
							"add oc, ft2, ft3\n";
			
			program.upload(ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
		}
		
		override public function dispose():void {
			super.dispose();
			program.dispose();
			program = null;
			containerProcess = null;
			data = null;
		}
		
	}

}