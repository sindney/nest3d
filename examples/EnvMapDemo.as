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
		
		[Embed(source = "assets/head_diffuse.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/head.obj", mimeType = "application/octet-stream")]
		private const model:Class;
		
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
			
			var data:MeshData = parser.parse(new model(), 10);
			var texture:EnvMapMaterial = new EnvMapMaterial(cubicmap, 0.4, new diffuse().bitmapData);
			texture.update();
			
			var mesh:Mesh = new Mesh(data, texture);
			scene.addChild(mesh);
			
			camera.position.z = 120;
			camera.rotation.y = Math.PI;
			camera.changed = true;
		}
		
	}

}