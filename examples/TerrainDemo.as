package  
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.Mesh;
	import nest.object.SkyBox;
	import nest.object.Terrain;
	import nest.view.lights.*;
	import nest.view.materials.EnvMapMaterial;
	import nest.view.materials.SkyBoxMaterial;
	import nest.view.materials.TextureMaterial;
	import nest.view.Shader3D;
	
	/**
	 * TerrainDemo
	 */
	public class TerrainDemo extends DemoBase {
		
		[Embed(source = "assets/skybox_top.jpg")]
		private const top:Class;
		
		[Embed(source = "assets/skybox_bottom.jpg")]
		private const bottom:Class;
		
		[Embed(source = "assets/skybox_right.jpg")]
		private const right:Class;
		
		[Embed(source = "assets/skybox_left.jpg")]
		private const left:Class;
		
		[Embed(source = "assets/skybox_front.jpg")]
		private const front:Class;
		
		[Embed(source = "assets/skybox_back.jpg")]
		private const back:Class;
		
		[Embed(source = "assets/terrain_diffuse.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/terrain_heights.jpg")]
		private const heightmap:Class;
		
		private var pointLight:PointLight;
		
		private var terrain:Terrain;
		
		public function TerrainDemo() {
			super();
		}
		
		override public function init():void {
			var dl:DirectionalLight = new DirectionalLight(0xffffff, 1, -1, 0.8);
			dl.normalize();
			
			pointLight = new PointLight(0xffffff, 400, 0, 0, 0);
			
			view.light = new AmbientLight(0x000000);
			view.light.next = dl;
			dl.next = pointLight;
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, true, false, false, false, false, true, view.light);
			
			var hm:BitmapData = new heightmap().bitmapData;
			
			var material:TextureMaterial = new TextureMaterial(new diffuse().bitmapData, null, 10, null, true);
			
			var cubicmap:Vector.<BitmapData> = new Vector.<BitmapData>();
			cubicmap[0] = new right().bitmapData;
			cubicmap[1] = new left().bitmapData;
			cubicmap[2] = new top().bitmapData;
			cubicmap[3] = new bottom().bitmapData;
			cubicmap[4] = new front().bitmapData;
			cubicmap[5] = new back().bitmapData;
			
			terrain = new Terrain(PrimitiveFactory.createPlane(1000, 1000, 100, 100), material, shader);
			terrain.heightMap = hm;
			terrain.width = 1000;
			terrain.height = 1000;
			terrain.segmentsW = 100;
			terrain.segmentsH = 100;
			terrain.magnitude = 1;
			terrain.update();
			scene.addChild(terrain);
			
			var skybox:SkyBox = new SkyBox(2000, new SkyBoxMaterial(cubicmap));
			scene.addChild(skybox);
			
			shader = new Shader3D();
			ShaderFactory.create(shader, true, false, false, false, true);
			var water:Mesh = new Mesh(PrimitiveFactory.createPlane(1000, 1000, 100, 100), new EnvMapMaterial(cubicmap, 0.8, new BitmapData(1, 1, false, 0x32328b)), shader);
			water.position.y = -50;
			water.changed = true;
			scene.addChild(water);
			
			speed = 10;
			camera.position.z = -10;
			camera.position.y = 10;
			camera.changed = true;
		}
		
		override public function loop():void {
			if (camera.position.x > 500) camera.position.x = 500;
			if (camera.position.x < -500) camera.position.x = -500;
			if (camera.position.y > 250) camera.position.y = 250;
			if (camera.position.z > 500) camera.position.z = 500;
			if (camera.position.z < -500) camera.position.z = -500;
			camera.changed = true;
			
			var p:Vector3D = camera.position.clone();
			terrain.getHeight(p);
			
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