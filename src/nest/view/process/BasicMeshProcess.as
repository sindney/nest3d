package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.IMesh;
	import nest.view.material.EnvMapMaterial;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * BasicMeshProcess
	 */
	public class BasicMeshProcess implements IMeshProcess {
		
		protected var _camera:Camera3D;
		
		public function BasicMeshProcess(camera:Camera3D) {
			_camera = camera;
		}
		
		public function initialize():void {
			var position:Vector.<Number> = new Vector.<Number>(4, true);
			position[0] = _camera.position.x;
			position[1] = _camera.position.y;
			position[2] = _camera.position.z;
			position[3] = 1;
			ViewPort.context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, position);
		}
		
		public function calculate(mesh:IMesh, ivm:Matrix3D, pm:Matrix3D):void {
			var context3d:Context3D = ViewPort.context3d;
			var components:Vector.<Vector3D>;
			var matrix:Matrix3D = new Matrix3D();
			
			context3d.setCulling(mesh.triangleCulling);
			
			matrix.copyFrom(mesh.worldMatrix);
			matrix.append(ivm);
			if (mesh.ignoreRotation) {
				components = matrix.decompose();
				components[1].setTo(0, 0, 0);
				matrix.recompose(components);
			}
			matrix.append(pm);
			
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
			
			if (mesh.material is EnvMapMaterial) {
				matrix.copyFrom(mesh.worldMatrix);
				components = matrix.decompose();
				components[0].setTo(0, 0, 0);
				components[2].setTo(1, 1, 1);
				matrix.recompose(components);
				context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 10, matrix, true);
			}
			
			matrix.copyFrom(mesh.invertWorldMatrix);
			matrix.appendScale(mesh.scale.x, mesh.scale.y, mesh.scale.z);
			
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, matrix, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 24, matrix, true);
			
			mesh.material.upload();
			mesh.geom.upload(mesh.material.uv, mesh.material.normal);
			
			context3d.setProgram(mesh.material.program);
			context3d.drawTriangles(mesh.geom.indexBuffer);
			
			mesh.material.unload();
			mesh.geom.unload();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get camera():Camera3D {
			return _camera;
		}
		
		public function set camera(value:Camera3D):void {
			_camera = value;
		}
		
	}

}