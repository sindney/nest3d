package  
{	
	import flash.geom.Vector3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.*;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	/**
	 * BasicDemo
	 */
	public class BasicDemo extends DemoBase {
		
		private var pointLight:PointLight;
		
		public function BasicDemo() {
			super();
		}
		
		override public function init():void {
			view.lights[0] = new AmbientLight(0x333333);
			
			pointLight = new PointLight(0xffffff, 200, 0, 0, 0);
			view.lights[1] = pointLight;
			
			var data:MeshData = PrimitiveFactory.createBox(10, 10, 10);
			
			var colorMat:ColorMaterial = new ColorMaterial(0xff0000);
			var colorMat1:ColorMaterial = new ColorMaterial(0x00ff00);
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, false, false, view.lights);
			
			var cube:Mesh;
			var i:int, j:int, k:int;
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					for (k = 0; k < 10; k++) {
						cube = new Mesh(data, i > 4 ? colorMat : colorMat1, shader);
						cube.position.setTo(i * 40, j * 40, k * 40);
						cube.changed = true;
						scene.addChild(cube);
					}
				}
			}
			
			speed = 10;
			camera.position.z = -20;
			camera.changed = true;
		}
		
		override public function loop():void {
			pointLight.position[0] = camera.position.x;
			pointLight.position[1] = camera.position.y;
			pointLight.position[2] = camera.position.z;
		}
		
	}

}