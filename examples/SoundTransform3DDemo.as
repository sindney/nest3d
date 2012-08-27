package  
{
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import nest.object.sounds.SoundTransform3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.object.Sound3D;
	import nest.object.SkyBox;
	import nest.view.materials.TextureMaterial;
	import nest.view.materials.IMaterial;
	import nest.view.materials.ColorMaterial;
	import nest.view.materials.SkyBoxMaterial;
	import nest.view.materials.EnvMapMaterial;
	
	/**
	 * SoundTransform3DDemo
	 */
	public class SoundTransform3DDemo extends DemoBase {
		
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
		
		private var rainSnd:Sound;
		private var soundTrans:SoundTransform3D;
		private var rainChannel:SoundChannel;
		
		public function SoundTransform3DDemo() {
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
			
			var mesh:Mesh = new Mesh(PrimitiveFactory.createPlane(100, 100, 4, 4), new EnvMapMaterial(cubicmap, 1, new BitmapData(1, 1, false)));
			mesh.material.update();
			scene.addChild(mesh);
			
			mesh = new Mesh(PrimitiveFactory.createPlane(10, 10, 1, 1), new ColorMaterial());
			mesh.material.update();
			mesh.position.setTo(50, 5, 50);
			mesh.rotation.setTo(Math.PI / 2, -Math.PI * 0.75, 0);
			mesh.changed = true;
			scene.addChild(mesh);
			
			var skyBox:SkyBox = new SkyBox(1000, new SkyBoxMaterial(cubicmap));
			skyBox.material.update();
			scene.addChild(skyBox);
			
			rainSnd = new rain() as Sound;
			rainChannel=rainSnd.play(0, 1000);
			
			soundTrans = new SoundTransform3D();
			soundTrans.near = 10;
			soundTrans.far = 100;
			soundTrans.volumn = 1;
			soundTrans.stopped = false;
			soundTrans.position.setTo(50, 0, 50);
			scene.addChild(soundTrans);
			rainChannel.soundTransform = soundTrans.transform;
			controller.speed = 1;
			camera.position.y = 10;
			camera.changed = true;
		}
		
		override public function loop():void {
			rainChannel.soundTransform = soundTrans.transform;
		}
	}

}