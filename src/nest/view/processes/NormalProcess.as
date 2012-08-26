package nest.view.processes 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.EngineBase;
	import nest.object.IMesh;
	import nest.object.Sprite3D;
	import nest.view.Shader3D;
	
	/**
	 * NormalProcess
	 */
	public class NormalProcess implements IProcess {
		
		private var draw:Matrix3D;
		private var shader:Shader3D;
		
		public function NormalProcess() {
			draw = new Matrix3D();
			shader = new Shader3D();
			shader.setFromString("m44 op, va0, vc0\nmov v0, va2" , "mov oc, v0", false);
		}
		
		public function doMesh(mesh:IMesh):void {
			var context3d:Context3D = EngineBase.context3d;
			
			draw.copyFrom(mesh.matrix);
			draw.append(EngineBase.camera.invertMatrix);
			if (mesh is Sprite3D) {
				var comps:Vector.<Vector3D> = draw.decompose();
				comps[1].setTo(0, 0, 0);
				draw.recompose(comps);
			}
			draw.append(EngineBase.camera.pm);
			
			context3d.setCulling(mesh.culling);
			context3d.setBlendFactors(mesh.blendMode.source, mesh.blendMode.dest);
			context3d.setDepthTest(mesh.blendMode.depthMask, Context3DCompareMode.LESS);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, draw, true);
			
			mesh.data.upload(context3d, false, true);
			
			context3d.setProgram(shader.program);
			context3d.drawTriangles(mesh.data.indexBuffer);
			
			mesh.data.unload(context3d);
		}
		
	}

}