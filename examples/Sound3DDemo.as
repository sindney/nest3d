package  
{
	import flash.media.Sound;
	
	import nest.control.factories.*;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.object.Sound3D;
	import nest.object.SkyBox;
	import nest.view.materials.TextureMaterial;
	import nest.view.materials.IMaterial;
	import nest.view.materials.ColorMaterial;
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
			var data:MeshData = PrimitiveFactory.createPlane(100, 100, 4, 4);
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, false);
			
			var mesh:Mesh = new Mesh(data, new ColorMaterial(), shader);
			scene.addChild(mesh);
			
			mesh = new Mesh(PrimitiveFactory.createPlane(10, 10, 1, 1), new ColorMaterial(0xffff00), shader);
			mesh.position.setTo(50, 5, 50);
			mesh.rotation.setTo(Math.PI / 2, -Math.PI * 0.75, 0);
			mesh.changed = true;
			scene.addChild(mesh);
			
			var skyBoxMat:Vector.<IMaterial> = new Vector.<IMaterial>(6, true);
			skyBoxMat[SkyBox.TOP] = new TextureMaterial(new top().bitmapData);
			skyBoxMat[SkyBox.BOTTOM] = new TextureMaterial(new bottom().bitmapData);
			skyBoxMat[SkyBox.LEFT] = new TextureMaterial(new left().bitmapData);
			skyBoxMat[SkyBox.RIGHT] = new TextureMaterial(new right().bitmapData);
			skyBoxMat[SkyBox.FRONT] = new TextureMaterial(new front().bitmapData);
			skyBoxMat[SkyBox.BACK] = new TextureMaterial(new back().bitmapData);
			
			shader = new Shader3D();
			ShaderFactory.create(shader);
			var skyBox:SkyBox = new SkyBox(1000, skyBoxMat, shader);
			scene.addChild(skyBox);
			
			var sound:Sound3D = new Sound3D(new rain() as Sound);
			sound.near = 10;
			sound.far = 100;
			sound.volumn = 1;
			sound.position.setTo(50, 0, 50);
			sound.play(1000);
			scene.addChild(sound);
			
			camera.position.y = 10;
			camera.changed = true;
		}
		
	}

}