package  
{
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.factories.*;
	import nest.object.data.*;
	import nest.object.Mesh;
	import nest.view.materials.ColorMaterial;
	import nest.view.materials.TextureMaterial;
	import nest.view.lights.*;
	import nest.view.Shader3D;
	
	/**
	 * LightDemo
	 */
	public class LightDemo extends DemoBase {
		
		[Embed(source = "assets/ground.jpg")]
		private const bitmap:Class;
		
		private var pointLight:PointLight;
		
		public function LightDemo() {
			super();
		}
		
		override public function init():void {
			view.lights[0] = new AmbientLight(0x000000);
			view.lights[1] = new DirectionalLight(0xffffff, 0, 1, 0);
			
			pointLight = new PointLight(0xffffff, 100, 0, 0, 0);
			view.lights[2] = pointLight;
			
			var data:MeshData = PrimitiveFactory.createSphere(20);
			var material:TextureMaterial = new TextureMaterial(new bitmap().bitmapData);
			var shader:Shader3D = new Shader3D(true, true);
			ShaderFactory.create(shader, view.lights);
			
			var mesh:Mesh = new Mesh(data, material, shader);
			mesh.position.x = -40;
			mesh.position.y = 40;
			mesh.changed = true;
			scene.addChild(mesh);
			
			mesh = new Mesh(data, material, shader);
			mesh.rotation.x = Math.PI / 4;
			mesh.changed = true;
			scene.addChild(mesh);
			
			mesh = new Mesh(data, material, shader);
			mesh.position.x = 40;
			mesh.position.y = 40;
			mesh.rotation.x = Math.PI / 4;
			mesh.changed = true;
			scene.addChild(mesh);
			
			camera.position.z = -80;
			camera.position.y = 50;
			camera.rotation.x = Math.PI / 18;
			camera.changed = true;
		}
		
		override public function loop():void {
			pointLight.position[0] = camera.position.x;
			pointLight.position[1] = camera.position.y;
			pointLight.position[2] = camera.position.z;
		}
		
	}

}