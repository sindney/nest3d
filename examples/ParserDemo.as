package  
{
	import nest.control.factories.ShaderFactory;
	import nest.control.parsers.OBJParser;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	/**
	 * ParserDemo
	 */
	public class ParserDemo extends DemoBase {
		
		[Embed(source = "assets/m4a1.jpg")]
		private const bitmap:Class;
		
		[Embed(source = "assets/m4a1.obj", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var target0:Mesh;
		private var target1:Mesh;
		private var target2:Mesh;
		
		public function ParserDemo() {
			super();
		}
		
		override public function init():void {
			view.lights[0] = new AmbientLight(0x333333);
			view.lights[1] = new DirectionalLight(0xffffff, 0, 2);
			
			var parser:OBJParser = new OBJParser();
			var data:MeshData = parser.parse(new model());
			
			var shader:Shader3D;
			
			var texture:TextureMaterial = new TextureMaterial(new bitmap().bitmapData);
			
			shader = new Shader3D(false, true);
			ShaderFactory.create(shader, view.lights);
			
			target0 = new Mesh(data, new ColorMaterial(), shader);
			target0.position.y = 200;
			target0.changed = true;
			scene.addChild(target0);
			
			shader = new Shader3D(true, true);
			ShaderFactory.create(shader, view.lights);
			
			target1 = new Mesh(data, texture, shader);
			scene.addChild(target1);
			
			shader = new Shader3D(true, false);
			ShaderFactory.create(shader);
			
			target2 = new Mesh(data, texture, shader);
			target2.position.y = -200;
			target2.changed = true;
			scene.addChild(target2);
			
			speed = 10;
			camera.position.x = -400;
			camera.position.z = 50;
			camera.rotation.y = Math.PI / 2;
			camera.changed = true;
		}
		
		override public function loop():void {
			if (keys[81]) {
				target0.rotation.z = target1.rotation.z = target2.rotation.z += 0.05;
				target0.changed = target1.changed = target2.changed = true;
			}
			if (keys[69]) {
				target0.rotation.z = target1.rotation.z = target2.rotation.z -= 0.05;
				target0.changed = target1.changed = target2.changed = true;
			}
		}
		
	}

}