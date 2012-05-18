package  
{
	import flash.media.Sound;
	
	import nest.control.factories.*;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.object.Sound3D;
	import nest.view.materials.ColorMaterial;
	import nest.view.Shader3D;
	
	/**
	 * Sound3DDemo
	 */
	public class Sound3DDemo extends DemoBase {
		
		[Embed(source = "assets/rain.mp3")]
		public const rain:Class;
		
		public function Sound3DDemo() {
			super();
		}
		
		override public function init():void {
			var data:MeshData = PrimitiveFactory.createPlane(100, 100, 4, 4);
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader);
			
			var mesh:Mesh = new Mesh(data, new ColorMaterial(), shader);
			scene.addChild(mesh);
			
			mesh = new Mesh(PrimitiveFactory.createPlane(10, 10, 1, 1), new ColorMaterial(0xffff00), shader);
			mesh.position.setTo(50, 5, 50);
			mesh.rotation.setTo(Math.PI / 2, -Math.PI * 0.75, 0);
			mesh.changed = true;
			scene.addChild(mesh);
			
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