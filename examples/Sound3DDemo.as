package  
{
	import flash.display.BitmapData;
	import flash.media.Sound;
	
	import nest.control.factories.*;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.object.Sound3D;
	import nest.object.SkyBox;
	import nest.view.materials.TextureMaterial;
	import nest.view.materials.IMaterial;
	import nest.view.materials.ColorMaterial;
	import nest.view.materials.SkyBoxMaterial;
	import nest.view.materials.EnvMapMaterial;
	import nest.view.Shader3D;
	
	/**
	 * Sound3DDemo
	 */
	public class Sound3DDemo extends DemoBase {
		
		[Embed(source = "assets/rain.mp3")]
		public const rain:Class;
		
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
		
		public function Sound3DDemo() {
			super();
		}
		
		override public function init():void {
			var cubicmap:Vector.<BitmapData> = new Vector.<BitmapData>(6, true);
			cubicmap[0] = new right().bitmapData;
			cubicmap[1] = new left().bitmapData;
			cubicmap[2] = new top().bitmapData;
			cubicmap[3] = new bottom().bitmapData;
			cubicmap[4] = new front().bitmapData;
			cubicmap[5] = new back().bitmapData;
			
			var shader:Shader3D = new Shader3D();
			var mesh:Mesh = new Mesh(PrimitiveFactory.createPlane(100, 100, 4, 4), new EnvMapMaterial(cubicmap, 1, new BitmapData(1, 1, false)), shader);
			ShaderFactory.create(shader, mesh.material);
			scene.addChild(mesh);
			
			shader = new Shader3D();
			mesh = new Mesh(PrimitiveFactory.createPlane(10, 10, 1, 1), new ColorMaterial(), shader);
			ShaderFactory.create(shader, mesh.material);
			mesh.position.setTo(50, 5, 50);
			mesh.rotation.setTo(Math.PI / 2, -Math.PI * 0.75, 0);
			mesh.changed = true;
			scene.addChild(mesh);
			
			var skyBox:SkyBox = new SkyBox(1000, new SkyBoxMaterial(cubicmap));
			scene.addChild(skyBox);
			
			var sound:Sound3D = new Sound3D(new rain() as Sound);
			sound.near = 10;
			sound.far = 100;
			sound.volumn = 1;
			sound.position.setTo(50, 0, 50);
			sound.play(1000);
			scene.addChild(sound);
			
			controller.speed = 1;
			camera.position.y = 10;
			camera.changed = true;
		}
		
	}

}