package  
{
	import flash.utils.ByteArray;
	
	import nest.control.factories.ShaderFactory;
	import nest.control.parsers.OBJParser;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	/**
	 * HeadDemo
	 */
	public class HeadDemo extends DemoBase {
		
		[Embed(source = "assets/head_diffuse.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/head_compressed.obj", mimeType = "application/octet-stream")]
		private const model:Class;
		
		public function HeadDemo() {
			super();
		}
		
		override public function init():void {
			view.lights[0] = new AmbientLight(0x333333);
			view.lights[1] = new DirectionalLight(0xffffff, 0, 0, -1);
			
			var parser:OBJParser = new OBJParser();
			var byte:ByteArray = new model();
			byte.uncompress();
			
			var data:MeshData = parser.parse(byte);
			var texture:TextureMaterial = new TextureMaterial(new diffuse().bitmapData);
			var shader:Shader3D = new Shader3D(true, true);
			ShaderFactory.create(shader, view.lights);
			
			var mesh:Mesh = new Mesh(data, texture, shader);
			mesh.scale.setTo(10, 10, 10);
			mesh.rotation.y = Math.PI;
			mesh.changed = true;
			scene.addChild(mesh);
			
			speed = 10;
			camera.position.z = -120;
			camera.changed = true;
		}
		
	}

}