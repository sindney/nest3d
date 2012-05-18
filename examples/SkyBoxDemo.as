package  
{
	import nest.control.factories.ShaderFactory;
	import nest.object.SkyBox;
	import nest.view.materials.TextureMaterial;
	import nest.view.materials.IMaterial;
	import nest.view.Shader3D;
	
	/**
	 * SkyBoxDemo
	 */
	public class SkyBoxDemo extends DemoBase {
		
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
		
		public function SkyBoxDemo() {
			super();
		}
		
		override public function init():void {
			var skyBoxMat:Vector.<IMaterial> = new Vector.<IMaterial>(6, true);
			skyBoxMat[SkyBox.TOP] = new TextureMaterial(new top().bitmapData);
			skyBoxMat[SkyBox.BOTTOM] = new TextureMaterial(new bottom().bitmapData);
			skyBoxMat[SkyBox.LEFT] = new TextureMaterial(new left().bitmapData);
			skyBoxMat[SkyBox.RIGHT] = new TextureMaterial(new right().bitmapData);
			skyBoxMat[SkyBox.FRONT] = new TextureMaterial(new front().bitmapData);
			skyBoxMat[SkyBox.BACK] = new TextureMaterial(new back().bitmapData);
			
			var shader:Shader3D = new Shader3D(true);
			ShaderFactory.create(shader);
			
			var skyBox:SkyBox = new SkyBox(1000, skyBoxMat, shader);
			scene.addChild(skyBox);
			
			speed = 10;
			camera.position.z = -20;
			camera.changed = true;
		}
	}

}