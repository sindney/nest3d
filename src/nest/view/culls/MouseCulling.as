package nest.view.culls 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	
	import nest.control.GlobalMethods;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.view.Shader3D;
	
	/**
	 * MouseCulling
	 */
	public class MouseCulling implements ICulling {
		
		private var draw:Matrix3D;
		private var shader:Shader3D;
		
		public var id:int;
		
		public function MouseCulling() {
			draw = new Matrix3D();
			shader = new Shader3D();
			shader.setFromString("m44 op, va0, vc0" , "mov oc, fc0", false);
		}
		
		public function classifyMesh(mesh:IMesh):Boolean {
			return mesh.mouseEnabled;
		}
		
		public function classifyContainer(container:IContainer3D):Boolean {
			return container.mouseEnabled;
		}
		
		public function doMesh(mesh:IMesh):void {
			var context3d:Context3D = GlobalMethods.context3d;
			
			mesh.id = ++id;
			draw.copyFrom(mesh.matrix);
			draw.append(GlobalMethods.camera.invertMatrix);
			draw.append(GlobalMethods.camera.pm);
			
			context3d.setCulling(mesh.culling);
			context3d.setBlendFactors(mesh.blendMode.source, mesh.blendMode.dest);
			context3d.setDepthTest(mesh.blendMode.depthMask, Context3DCompareMode.LESS);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, draw, true);
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, ((id >> 8) & 0xff) / 255, (id & 0xff) / 255, 1]));
			
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
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get customize():Boolean {
			return true;
		}
		
	}

}