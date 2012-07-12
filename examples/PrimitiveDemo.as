package  
{
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.lights.AmbientLight;
	import nest.view.lights.DirectionalLight;
	import nest.view.materials.ColorMaterial;
	import nest.view.materials.TextureMaterial;
	import nest.view.Shader3D;
	
	/**
	 * SphereDemo
	 */
	public class PrimitiveDemo extends DemoBase {
		
		[Embed(source = "assets/box.jpg")]
		private const bitmap:Class;
		
		public function PrimitiveDemo() {
			super();
		}
		
		override public function init():void {
			var light:AmbientLight = new AmbientLight(0x333333);
			light.next = new DirectionalLight();
			light.next.next = new DirectionalLight(0xffff00, -1, -1);
			
			var material:TextureMaterial = new TextureMaterial(new bitmap().bitmapData);
			material.light = light;
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, true, false, false, false, false, false, light);
			
			var mesh:Mesh = new Mesh(PrimitiveFactory.createSphere(5, 8, 6), material, shader);
			scene.addChild(mesh);
			
			mesh = new Mesh(PrimitiveFactory.createBox(10, 10, 10), material, shader);
			mesh.position.x = 10;
			mesh.changed = true;
			scene.addChild(mesh);
			
			mesh = new Mesh(PrimitiveFactory.createPlane(10, 10), material, shader);
			mesh.position.x = -10;
			mesh.changed = true;
			scene.addChild(mesh);
			
			camera.position.z = -20;
			camera.changed = true;
		}
		
	}

}