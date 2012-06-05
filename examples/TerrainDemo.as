package  
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.Terrain;
	import nest.view.effects.*;
	import nest.view.lights.*;
	import nest.view.materials.TextureMaterial;
	import nest.view.Shader3D;
	
	/**
	 * TerrainDemo
	 */
	public class TerrainDemo extends DemoBase {
		
		[Embed(source = "assets/terrain_diffuse.jpg")]
		private const terrain:Class;
		
		[Embed(source = "assets/terrain_heights.jpg")]
		private const heightmap:Class;
		
		private var pointLight:PointLight;
		
		private var mesh:Terrain;
		
		public function TerrainDemo() {
			super();
		}
		
		override public function init():void {
			view.lights[0] = new AmbientLight(0x000000);
			view.lights[1] = new DirectionalLight(0xffffff, -1);
			(view.lights[1] as DirectionalLight).normalize();
			
			pointLight = new PointLight(0xffffff, 200, 0, 0, 0);
			view.lights[2] = pointLight;
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, true, false, view.lights);
			
			var hm:BitmapData = new heightmap().bitmapData;
			//var hm:BitmapData = new BitmapData(512, 512, false);
			//hm.perlinNoise(512, 512, 10, int.MAX_VALUE * Math.random(), true, true, 7, true);
			
			var material:TextureMaterial = new TextureMaterial(new terrain().bitmapData);
			
			mesh = new Terrain(PrimitiveFactory.createPlane(1000, 1000, 100, 100), material, shader);
			mesh.heightMap = hm;
			mesh.width = 1000;
			mesh.height = 1000;
			mesh.segmentsW = 100;
			mesh.segmentsH = 100;
			mesh.magnitude = 1;
			mesh.update();
			scene.addChild(mesh);
			
			speed = 10;
			camera.position.z = -10;
			camera.position.y = 10;
			camera.changed = true;
		}
		
		override public function loop():void {
			var p:Vector3D = camera.position.clone();
			mesh.getHeight(p);
			
			if (camera.position.y < p.y + 10) {
				camera.position.y = p.y + 10;
				camera.changed = true;
			}
			
			pointLight.position[0] = camera.position.x;
			pointLight.position[1] = camera.position.y;
			pointLight.position[2] = camera.position.z;
		}
		
	}

}