package  
{
	import nest.control.animation.AnimationClip;
	import nest.control.parsers.ParserMD2;
	import nest.object.Mesh;
	import nest.view.materials.TextureMaterial;
	/**
	 *
	 */
	public class VertexAnimationDemo extends DemoBase
	{
		[Embed(source = "assets/Marvin.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/Marvin.md2", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var mesh:Mesh;
		private var parser:ParserMD2;
		
		public function VertexAnimationDemo() 
		{
			super();
		}
		
		private var material:TextureMaterial;
		private var clip:AnimationClip;
		
		override public function init():void {
			parser = new ParserMD2();
			mesh = parser.parse(new model(), .25);
			
			material = new TextureMaterial(new diffuse().bitmapData);
			material.update();
			mesh.material = material;
			
			clip = mesh.clips[0];
			//clip = clip.slice(1, 40);
			clip.loops = int.MAX_VALUE;
			clip.speed = 10;
			clip.target = mesh;
			mesh.clips[0] = clip;
			clip.play();
			
			mesh.rotation.x = -Math.PI / 2;
			mesh.rotation.y = Math.PI / 2;
			mesh.changed = true;
			scene.addChild(mesh);
			
			camera.position.z = -20;
			camera.changed = true;
			
			controller.speed = 1;
		}
		
		override public function loop():void {
			clip.update();
		}
	}

}