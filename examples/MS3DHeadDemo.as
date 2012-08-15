package  
{
	import nest.control.factories.ShaderFactory;
	import nest.control.parsers.ParserMS3D;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	/**
	 * MS3DHeadDemo
	 */
	public class MS3DHeadDemo extends DemoBase {
		
		[Embed(source = "assets/head_specular.jpg")]
		private const specular:Class;
		
		[Embed(source = "assets/head_diffuse.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/head_normals.jpg")]
		private const normals:Class;
		
		[Embed(source = "assets/head.ms3d", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var mesh:Mesh;
		
		public function MS3DHeadDemo() {
			super();
		}
		
		override public function init():void {
			var light:AmbientLight = new AmbientLight(0x000000);
			light.next = new DirectionalLight(0xffffff, 0, 0, -1);
			
			var parser:ParserMS3D = new ParserMS3D();
			mesh = parser.parse(new model(), 10) as Mesh;
			
			var texture:TextureMaterial = new TextureMaterial(new diffuse().bitmapData, new specular().bitmapData, 40, new normals().bitmapData);
			texture.light = light;
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, light, true, true, true, false, false, false);
			
			mesh.material = texture;
			mesh.shader = shader;
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