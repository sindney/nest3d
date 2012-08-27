package  
{
	import flash.display.BitmapData;
	import nest.control.parsers.ParserOBJ;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.materials.*;
	
	/**
	 * EnvMapDemo
	 */
	public class EnvMapDemo extends DemoBase {
		
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
		
		[Embed(source = "assets/teapot.obj", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var mesh:Mesh;
		
		public function EnvMapDemo() {
			super();
		}
		
		override public function init():void {
			var parser:ParserOBJ = new ParserOBJ();
			
			var cubicmap:Vector.<BitmapData> = new Vector.<BitmapData>(6, true);
			cubicmap[0] = new right().bitmapData;
			cubicmap[1] = new left().bitmapData;
			cubicmap[2] = new top().bitmapData;
			cubicmap[3] = new bottom().bitmapData;
			cubicmap[4] = new front().bitmapData;
			cubicmap[5] = new back().bitmapData;
			
			var data:MeshData = parser.parse(new model(), 5);
			var texture:EnvMapMaterial = new EnvMapMaterial(cubicmap, 0.8, new BitmapData(1, 1, false, 0xffffff));
			texture.update();
			
			mesh = new Mesh(data, texture);
			mesh.position.z = 200;
			mesh.changed = true;
			scene.addChild(mesh);
			
			camera.position.y = 20;
			camera.changed = true;
		}
		
		override public function loop():void {
			mesh.rotation.y += 0.01;
			mesh.changed = true;
		}
	}

}