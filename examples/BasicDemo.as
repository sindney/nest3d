package  
{	
	import flash.events.MouseEvent;
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
		
		private var colorMat:ColorMaterial;
		private var colorMat1:ColorMaterial;
		
		override public function init():void {
			var light:AmbientLight = new AmbientLight(0x333333);
			light.next = pointLight = new PointLight(0xffffff, 200, 0, 0, 0);
			
			var data:MeshData = PrimitiveFactory.createBox(10, 10, 10);
			
			colorMat = new ColorMaterial(0xff0000);
			colorMat.light = light;
			colorMat1 = new ColorMaterial(0x00ff00);
			colorMat1.light = light;
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, light, false);
			
			var cube:Mesh;
			var i:int, j:int, k:int = 0;
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					for (k = 0; k < 10; k++) {
						cube = new Mesh(data, k > 4 ? colorMat : colorMat1, shader);
						cube.position.setTo(i * 40, j * 40, k * 40);
						cube.changed = true;
						scene.addChild(cube);
					}
				}
			}
			
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