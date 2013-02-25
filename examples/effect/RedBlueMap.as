package effect 
{
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.IMesh;
	import nest.view.process.IContainerProcess;
	import nest.view.shader.Shader3D;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * RedBlueMap
	 * <p>Just need to call comply() once.</p>
	 */
	public class RedBlueMap extends PostEffect {
		
		private var program:Program3D;
		
		private var data:Vector.<Number>;
		
		public var texture0:TextureBase;
		public var texture1:TextureBase;
		
		public var containerProcess:IContainerProcess;
		public var eyePadding:Number;
		
		public function RedBlueMap(width:int = 512, height:int = 512, containerProcess:IContainerProcess = null, eyePadding:Number = 1) {
			super();
			var context3d:Context3D = ViewPort.context3d;
			
			program = context3d.createProgram();
			
			data = Vector.<Number>([1, 0, 0, 1, 0, 1, 1, 1]);
			
			this.containerProcess = containerProcess;
			this.eyePadding = eyePadding;
			
			texture0 = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, true);
			texture1 = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, true);
			
			comply();
		}
		
		override public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			var camera:Camera3D = containerProcess.camera;
			
			context3d.setRenderToTexture(texture1, true, 0);
			context3d.clear();
			
			var p:Vector3D = new Vector3D(1, 0, 0);
			p.scaleBy(eyePadding);
			camera.position.copyFrom(camera.matrix.transformVector(p));
			camera.recompose();
			
			var pm:Matrix3D = camera.invertMatrix.clone();
			pm.append(camera.pm);
			
			var pm1:Matrix3D = camera.invertMatrix.clone();
			var comps:Vector.<Vector3D> = pm1.decompose();
			comps[1].setTo(0, 0, 0);
			pm1.recompose(comps);
			pm1.append(camera.pm);
			
			var mesh:IMesh;
			for each(mesh in containerProcess.objects) {
				containerProcess.meshProcess.calculate(mesh, mesh.ignoreRotation ? pm1 : pm);
			}
			
			context3d.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			for each(mesh in containerProcess.alphaObjects) {
				containerProcess.meshProcess.calculate(mesh, mesh.ignoreRotation ? pm1 : pm);
			}
			
			context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			
			p.setTo(1, 0, 0);
			p.scaleBy( -eyePadding);
			camera.position.copyFrom(camera.matrix.transformVector(p));
			camera.recompose();
			
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias, _renderTarget.surfaceSelector);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data, 2);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setTextureAt(0, texture0);
			context3d.setTextureAt(1, texture1);
			context3d.setProgram(program);
			context3d.drawTriangles(indexBuffer);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setTextureAt(0, null);
			context3d.setTextureAt(1, null);
		}
		
		public function comply():void {
			var vs:String = "mov op, va0\n" + 
							"mov v0, va1\n";
			
			var fs:String = "tex ft0, v0, fs0 <2d, nearest, clamp, mipnone>\n" + 
							"tex ft1, v0, fs1 <2d, nearest, clamp, mipnone>\n" + 
							"mul ft2, ft0, fc0\n" + 
							"mul ft3, ft1, fc1\n" + 
							"add oc, ft2, ft3\n";
			
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
		}
		
		override public function dispose():void {
			super.dispose();
			program.dispose();
			program = null;
			containerProcess = null;
			data = null;
			if (texture0) texture0.dispose();
			texture0 = null;
			if (texture1) texture1.dispose();
			texture1 = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		override public function get texture():TextureBase {
			return texture0;
		}
	}

}