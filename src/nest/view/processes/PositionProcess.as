package nest.view.processes 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	
	import nest.control.GlobalMethods;
	import nest.object.IMesh;
	import nest.view.Shader3D;
	
	/**
	 * PositionProcess
	 */
	public class PositionProcess implements IProcess {
		
		private var draw:Matrix3D;
		private var shader:Shader3D;
		
		public function PositionProcess() {
			draw = new Matrix3D();
			shader = new Shader3D();
			shader.setFromString("m44 op, va0, vc0\nmov va0, v0" , "mov oc, v0", false);
		}
		
		public function doMesh(mesh:IMesh):void {
			var context3d:Context3D = GlobalMethods.context3d;
			
			draw.copyFrom(mesh.matrix);
			draw.append(GlobalMethods.camera.invertMatrix);
			draw.append(GlobalMethods.camera.pm);
			
			context3d.setCulling(mesh.culling);
			context3d.setBlendFactors(mesh.blendMode.source, mesh.blendMode.dest);
			context3d.setDepthTest(mesh.blendMode.depthMask, Context3DCompareMode.LESS);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, draw, true);
			
			mesh.data.upload(context3d, false, false);
			
			if (shader.changed) {
				shader.changed = false;
				if (!shader.program) shader.program = context3d.createProgram();
				shader.program.upload(shader.vertex, shader.fragment);
			}
			
			context3d.setProgram(shader.program);
			context3d.drawTriangles(mesh.data.indexBuffer);
			
			mesh.data.unload(context3d);
		}
		
	}

}