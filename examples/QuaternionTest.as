package  
{
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.*;
	import nest.object.geom.Quaternion;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	/**
	 * QuaternionTest
	 */
	public class QuaternionTest extends DemoBase {
		
		public function QuaternionTest() {
			super();
		}
		
		override public function init():void {
			view.lights[0] = new AmbientLight(0x333333);
			
			view.lights[1] = new DirectionalLight(0xffffff, 1.414, 1.414);
			
			var data:MeshData = PrimitiveFactory.createBox(10, 10, 10);
			
			var material:ColorMaterial = new ColorMaterial(0x00ff00);
			
			var shader:Shader3D = new Shader3D(false, true);
			ShaderFactory.create(shader, view.lights);
			
			var cube:Mesh = new Mesh(data, material, shader)
			cube.orientation = Orientation3D.QUATERNION;
			Quaternion.rotationX(cube.rotation, Math.PI / 4);
			cube.changed = true;
			scene.addChild(cube);
			
			speed = 5;
			camera.position.z = -20;
			camera.changed = true;
		}
		
	}

}