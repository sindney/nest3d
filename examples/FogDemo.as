package  
{
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.materials.ColorMaterial;
	import nest.view.Shader3D;
	
	/**
	 * FogDemo
	 */
	public class FogDemo extends DemoBase {
		
		public function FogDemo() {
			super();
		}
		
		override public function init():void {
			view.setupFog(0x0066ff, 400, 0);
			view.fog = true;
			view.color = 0x0066ff;
			
			camera.far = 400;
			
			var data:MeshData = PrimitiveFactory.createBox(10, 10, 10);
			
			var colorMat:ColorMaterial = new ColorMaterial(0xffffff);
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, null, false, false, false, false, false, false, true);
			
			var cube:Mesh;
			var i:int, j:int, k:int;
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					for (k = 0; k < 10; k++) {
						cube = new Mesh(data, colorMat, shader);
						cube.position.setTo(i * 40, j * 40, k * 40);
						cube.changed = true;
						scene.addChild(cube);
					}
				}
			}
			
			camera.position.z = -20;
			camera.changed = true;
		}
	}

}