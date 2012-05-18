package  
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	import bloom.components.CheckBox;
	import bloom.components.CheckBoxGroup;
	import bloom.components.FlowContainer;
	import bloom.components.Label;
	import bloom.core.ThemeBase;
	import bloom.themes.BlueTheme;
	
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
		
		private var pe_grayScale:GrayScale;
		private var pe_nightVision:NightVision;
		private var pe_sepia:Sepia;
		
		private var shader:Shader3D;
		
		private var pointLight:PointLight;
		
		private var mesh:Terrain;
		
		public function TerrainDemo() {
			super();
		}
		
		override public function init():void {
			view.lights[0] = new AmbientLight(0x000000);
			
			var light:DirectionalLight = new DirectionalLight(0xffffff);
			light.direction[0] = 1;
			light.direction[1] = 0.4;
			view.lights[1] = light;
			
			pointLight = new PointLight(0xffffff, 200, 0, 0, 0);
			view.lights[2] = pointLight;
			
			pe_grayScale = new GrayScale();
			pe_nightVision = new NightVision();
			pe_sepia = new Sepia();
			
			shader = new Shader3D(true, true);
			ShaderFactory.create(shader, view.lights);
			
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
			
			// setup ui
			ThemeBase.initialize(stage);
			ThemeBase.theme = new BlueTheme();
			
			var flow:FlowContainer = new FlowContainer(this);
			
			var cbg:CheckBoxGroup = new CheckBoxGroup( -1);
			var checkbox:CheckBox = new CheckBox(flow.content, "None", false);
			cbg.addChild(checkbox);
			checkbox = new CheckBox(flow.content, "GrayScale", false);
			cbg.addChild(checkbox);
			checkbox = new CheckBox(flow.content, "NightVision", false);
			cbg.addChild(checkbox);
			checkbox = new CheckBox(flow.content, "Sepia", false);
			cbg.addChild(checkbox);
			
			cbg.index = 0;
			cbg.add(onPEChanged);
			
			flow.update();
			flow.size(120, 120);
			flow.move(5, 85);
		}
		
		private function onPEChanged(cbg:CheckBoxGroup):void {
			switch(cbg.index) {
				case 0:
					view.effect = null;
					ShaderFactory.create(shader, view.lights);
					break;
				case 1:
					view.effect = pe_grayScale;
					ShaderFactory.create(shader, view.lights, pe_grayScale);
					break;
				case 2:
					view.effect = pe_nightVision;
					ShaderFactory.create(shader, view.lights, pe_nightVision);
					break;
				case 3:
					view.effect = pe_sepia;
					ShaderFactory.create(shader, view.lights, pe_sepia);
					break;
			}
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