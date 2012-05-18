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
	 * PressureTest
	 */
	public class PressureTest extends DemoBase {
		
		[Embed(source = "assets/sphere_compressed.obj", mimeType = "application/octet-stream")]
		private const model:Class;
		
		public function PressureTest() {
			super();
		}
		
		override public function init():void {
			var parser:OBJParser = new OBJParser();
			var byte:ByteArray = new model();
			byte.uncompress();
			var data:MeshData = parser.parse(byte);
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader);
			
			var mesh:Mesh = new Mesh(data, new ColorMaterial(), shader);
			scene.addChild(mesh);
			
			var material:ColorMaterial;
			for (var i:int = 0; i < 200; i++) {
				if (i < 40) {
					material = new ColorMaterial(0xffffff);
				} else if (i < 80) {
					material = new ColorMaterial(0xffff00);
				} else if (i < 120) {
					material = new ColorMaterial(0xff0000);
				} else if (i < 160) {
					material = new ColorMaterial(0x00ffff);
				} else if (i < 200) {
					material = new ColorMaterial(0x0000ff);
				}
				mesh = new Mesh(data, material, shader);
				mesh.position.z = i * 20;
				mesh.changed = true;
				scene.addChild(mesh);
			}
			
			speed = 10;
			camera.position.z = -100;
			camera.changed = true;
		}
		
	}

}