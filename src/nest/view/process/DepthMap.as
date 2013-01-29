package nest.view.process 
{
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.factory.ShaderFactory;
	import nest.object.IMesh;
	import nest.view.ViewPort;
	
	/**
	 * DepthMap
	 * <p>Decode:</p>
	 * <p>dp4, dest, color, fc</p>
	 * <p>fc: 1 / (256 * 256 * 256), 1 / (256 * 256), 1 / 256, 1</p>
	 */
	public class DepthMap implements IRenderProcess {
		
		private var _renderTarget:RenderTarget;
		
		private var program:Program3D;
		private var data:Vector.<Number>;
		
		public var containerProcess:IContainerProcess;
		
		public function DepthMap(containerProcess:IContainerProcess = null) {
			var context3d:Context3D = ViewPort.context3d;
			
			var vs:String = "m44 vt0, va0, vc0\nmov v0, vt0\nmov op, vt0\n";
			
			var fs:String = "mov ft0, v0.z\n" + 
							"mul ft0, ft0, fc0\n" + 
							"frc ft0, ft0\n" + 
							"mul ft1, ft0.xxyz, fc1\n" + 
							"sub oc, ft0, ft1\n";
			
			program = context3d.createProgram();
			program.upload(ShaderFactory.assembler.assemble(Context3DProgramType.VERTEX, vs), 
							ShaderFactory.assembler.assemble(Context3DProgramType.FRAGMENT, fs));
			
			data = Vector.<Number>([256 * 256 * 256, 256 * 256, 256, 1, 0, 1 / 256, 1 / 256, 1 / 256]);
			
			this.containerProcess = containerProcess;
			
			_renderTarget = new RenderTarget();
		}
		
		public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias, _renderTarget.surfaceSelector);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear();
			
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, data, 2);
			
			var mesh:IMesh;
			var components:Vector.<Vector3D>;
			var matrix:Matrix3D = new Matrix3D();
			
			for each(mesh in containerProcess.objects) {
				context3d.setCulling(mesh.triangleCulling);
				
				matrix.copyFrom(mesh.worldMatrix);
				matrix.append(containerProcess.camera.invertMatrix);
				if (mesh.ignoreRotation) {
					components = matrix.decompose();
					components[1].setTo(0, 0, 0);
					matrix.recompose(components);
				}
				matrix.append(containerProcess.camera.pm);
				
				context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
				
				mesh.geom.upload(false, false);
				
				context3d.setProgram(program);
				context3d.drawTriangles(mesh.geom.indexBuffer);
				
				mesh.geom.unload();
			}
			
			context3d.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			for each(mesh in containerProcess.alphaObjects) {
				context3d.setCulling(mesh.triangleCulling);
				
				matrix.copyFrom(mesh.worldMatrix);
				matrix.append(containerProcess.camera.invertMatrix);
				if (mesh.ignoreRotation) {
					components = matrix.decompose();
					components[1].setTo(0, 0, 0);
					matrix.recompose(components);
				}
				matrix.append(containerProcess.camera.pm);
				
				context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
				
				mesh.geom.upload(false, false);
				
				context3d.setProgram(program);
				context3d.drawTriangles(mesh.geom.indexBuffer);
				
				mesh.geom.unload();
			}
			
			context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
		}
		
		public function dispose():void {
			super.dispose();
			program.dispose();
			program = null;
			data = null;
			_renderTarget = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get renderTarget():RenderTarget {
			return _renderTarget;
		}
		
	}

}