package  
{
	import nest.control.parsers.ParserOBJ;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.effects.*;
	import nest.view.lights.*;
	import nest.view.materials.ColorMaterial;
	
	/**
	 * PostEffectDemo
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
			
			effects = Vector.<IPostEffect>([null, new TransformColor(TransformColor.NIGHT_VISION), new TransformColor(TransformColor.SEPIA), new GrayScale(), new InverseColor(), new Blur(10, 10),new Pixelation(20,20),new CellShader(4,4,4,4),new ConvolutionFilter(ConvolutionFilter.BEVEL)]);
			
			var parser:ParserOBJ = new ParserOBJ();
			
			var data:MeshData = parser.parse(new model(), 10);
			var texture:ColorMaterial = new ColorMaterial(0xffffff);
			texture.light = new AmbientLight(0x333333);
			texture.light.next = new DirectionalLight(0xffffff, 1, -1);
			(texture.light.next as DirectionalLight).normalize();
			texture.update();
			
			mesh = new Mesh(data, texture);
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