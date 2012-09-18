package nest.view.process 
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
	 * IDProcess
	 */
	public class IDProcess implements IProcess {
		
		private var draw:Matrix3D;
		private var shader:Shader3D;
		
		public var id:int;
		
		public function IDProcess() {
			draw = new Matrix3D();
			shader = new Shader3D();
			shader.setFromString("m44 op, va0, vc0" , "mov oc, fc0", false);
		}
		
		public function doMesh(mesh:IMesh):void {
			var context3d:Context3D = EngineBase.context3d;
			
			mesh.id = ++id;
			draw.copyFrom(mesh.worldMatrix);
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
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, ((id >> 8) & 0xff) / 255, (id & 0xff) / 255, 1]));
			
			mesh.data.upload(context3d, false, false);
			
			context3d.setProgram(shader.program);
			context3d.drawTriangles(mesh.data.indexBuffer);
			
			mesh.data.unload(context3d);
		}
		
	}

}