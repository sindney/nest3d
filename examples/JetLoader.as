package  
{
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.geom.Orientation3D;
	import nest.object.Container3D;
	import nest.view.effects.Bloom;
	
	import nest.control.mouse.*;
	import nest.control.parsers.ParserMS3D;
	import nest.object.data.MeshData;
	import nest.object.geom.Quaternion;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	
	/**
	 * JetLoader
	 */
	public class JetLoader extends DemoBase {
		
		[Embed(source = "assets/su34.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/su34-specular.jpg")]
		private const specular:Class;
		
		[Embed(source = "assets/su34.ms3d", mimeType = "application/octet-stream")]
		private const model:Class;
		
		public function JetLoader() {
			super();
		}
		
		override public function init():void {
			var light:AmbientLight = new AmbientLight(0x555555);
			light.next = new DirectionalLight(0xffffff, 0, -1, -1);
			
			var parser:ParserMS3D = new ParserMS3D();
			parser.parse(new model(), 2);
			
			var texture:TextureMaterial = new TextureMaterial(new diffuse().bitmapData, new specular().bitmapData, 40);
			texture.light = light;
			texture.update();
			
			var axis:Vector3D = new Vector3D();
			
			jet = new Container3D();
			jet.rotation.x = Math.PI / 4;
			jet.changed = true;
			jet.mouseEnabled = true;
			scene.addChild(jet);
			
			var mesh:Mesh = parser.getObjectByName("main");
			mesh.material = texture;
			mesh.changed = true;
			jet.addChild(mesh);
			
			var p0:Mesh = parser.getObjectByName("part0");
			p0.material = texture;
			p0.position.setTo(72, -10, 240);
			p0.rotation.x = Math.PI / 6;
			p0.changed = true;
			p0.mouseEnabled = true;
			p0.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			jet.addChild(p0);
			
			var p1:Mesh = parser.getObjectByName("part1");
			p1.material = texture;
			p1.position.setTo( -72, -10, 240);
			p1.rotation.x = Math.PI / 6;
			p1.changed = true;
			p1.mouseEnabled = true;
			p1.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			jet.addChild(p1);
			
			var p2:Mesh = parser.getObjectByName("part2");
			p2.material = texture;
			p2.position.setTo(72, 4, 200);
			p2.recompose();
			p2.matrix.appendRotation(45, new Vector3D(0, 1, 0.2), p2.position);
			p2.decompose();
			p2.mouseEnabled = true;
			p2.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			jet.addChild(p2);
			
			var p3:Mesh = parser.getObjectByName("part3");
			p3.material = texture;
			p3.position.setTo( -72, 4, 200);
			p3.changed = true;
			p3.mouseEnabled = true;
			p3.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			jet.addChild(p3);
			
			var p4:Mesh = parser.getObjectByName("part4");
			p4.material = texture;
			p4.position.setTo(72, 10, 112);
			p4.recompose();
			p4.matrix.appendRotation(45, new Vector3D(1, 0, 0.2), p4.position);
			p4.decompose();
			p4.mouseEnabled = true;
			p4.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			jet.addChild(p4);
			
			var p5:Mesh = parser.getObjectByName("part5");
			p5.material = texture;
			p5.position.setTo( -72, 10, 112);
			p5.changed = true;
			p5.mouseEnabled = true;
			p5.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			jet.addChild(p5);
			target = p5;
			scene.mouseEnabled = true;
			view.mouseManager = new MouseManager();
			
			view.effect = new Bloom(8, 8, 0.25);
			
			view.color = 0x333333;
			controller.speed = 40;
			camera.position.z = 800;
			camera.rotation.y = Math.PI;
			camera.changed = true;
		}
		
		private var target:Mesh;
		private var jet:Container3D;
		
		private function onMouseDown(e:MouseEvent3D):void {
			target = e.target as Mesh;
		}
		
		override public function loop():void {
			if (target) {
				if (controller.keys[Keyboard.R]) target.rotation.x += 0.1;
				else if (controller.keys[Keyboard.F]) target.rotation.x -= 0.1;
				else if (controller.keys[Keyboard.T]) target.rotation.y += 0.1;
				else if (controller.keys[Keyboard.G]) target.rotation.y -= 0.1;
				else if (controller.keys[Keyboard.Y]) target.rotation.z += 0.1;
				else if (controller.keys[Keyboard.H]) target.rotation.z -= 0.1;
				target.changed = true;
			}
			//jet.rotation.x += 0.1;
			//jet.changed = true;
		}
		
	}

}