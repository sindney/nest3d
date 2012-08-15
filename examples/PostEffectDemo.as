package  
{
	import flash.ui.Keyboard;
	import nest.control.factories.ShaderFactory;
	import nest.control.parsers.ParserOBJ;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.effects.*;
	import nest.view.lights.*;
	import nest.view.materials.ColorMaterial;
	import nest.view.Shader3D;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class PostEffectDemo extends DemoBase {
		
		[Embed(source = "assets/teapot.obj", mimeType = "application/octet-stream")]
		private const model:Class;
		private var mesh:Mesh;
		
		private var effects:Vector.<IPostEffect>;
		private var index:uint = 0;
		
		public function PostEffectDemo() {
			super();
		}
		
		override public function init():void {
			effects = Vector.<IPostEffect>([null, new NightVision(), new Gray(), new InverseColor(), new Blur(10, 10)]);
			
			var parser:ParserOBJ = new ParserOBJ();
			
			var data:MeshData = parser.parse(new model(), 10);
			var texture:ColorMaterial = new ColorMaterial(0x0066ff);
			texture.light = new AmbientLight(0x333333);
			texture.light.next = new DirectionalLight(0xffffff, 1, -1);
			(texture.light.next as DirectionalLight).normalize();
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, texture.light, false);
			
			mesh = new Mesh(data, texture, shader);
			scene.addChild(mesh);
			
			camera.position.setTo(0, 50, 250);
			camera.rotation.setTo(0, Math.PI, 0);
			camera.changed = true;
		}
		
		override public function loop():void {
			mesh.rotation.y += 0.01;
			mesh.changed = true;
			var i:int = 49;
			while (i < effects.length + 49) {
				if (controller.keys[i]) {
					view.effect = effects[i - 49];
				}
				i++;
			}
		}
	}

}