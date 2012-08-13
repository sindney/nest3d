package  
{
	import nest.control.factories.ShaderFactory;
	import nest.control.parsers.ParserOBJ;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	/**
	 * HeadDemo
	 */
	public class HeadDemo extends DemoBase {
		
		[Embed(source = "assets/head_specular.jpg")]
		private const specular:Class;
		
		[Embed(source = "assets/head_diffuse.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/head_normals.jpg")]
		private const normals:Class;
		
		[Embed(source = "assets/head.obj", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var mesh:Mesh;
		
		public function HeadDemo() {
			super();
		}
		
		override public function init():void {
			var parser:ParserOBJ = new ParserOBJ();
			
			var data:MeshData = parser.parse(new model(), 10);
			var texture:TextureMaterial = new TextureMaterial(new diffuse().bitmapData, new specular().bitmapData, 40, new normals().bitmapData, true);
			texture.light = new AmbientLight(0x000000);
			texture.light.next = new DirectionalLight(0xffffff, 0, 0, -1);
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, true, true, true, false, false, false, texture.light);
			
			mesh = new Mesh(data, texture, shader);
			scene.addChild(mesh);
			
			camera.position.z = 120;
			camera.rotation.y = Math.PI;
			camera.changed = true;
		}
		
		override public function loop():void {
			mesh.rotation.y += 0.01;
			mesh.changed = true;
		}
		
	}

}