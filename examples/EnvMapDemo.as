package  
{
	import flash.display.BitmapData;
	
	import nest.control.factory.PrimitiveFactory;
	import nest.object.geom.Geometry;
	import nest.object.Container3D;
	import nest.object.Mesh;
	import nest.view.material.*;
	import nest.view.process.BasicMeshProcess;
	import nest.view.process.ContainerProcess;
	
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
		
		private var mesh:Mesh;
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		
		public function EnvMapDemo() {
			super();
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new BasicMeshProcess(camera);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var geom:Geometry = PrimitiveFactory.createSphere(100, 16, 12);
			
			var cubicmap:Vector.<BitmapData> = new Vector.<BitmapData>(6, true);
			cubicmap[0] = new right().bitmapData;
			cubicmap[1] = new left().bitmapData;
			cubicmap[2] = new top().bitmapData;
			cubicmap[3] = new bottom().bitmapData;
			cubicmap[4] = new front().bitmapData;
			cubicmap[5] = new back().bitmapData;
			
			var texture:EnvMapMaterial = new EnvMapMaterial(cubicmap, 0.8, new BitmapData(1, 1, false, 0xffffff));
			texture.comply();
			
			mesh = new Mesh(geom, texture);
			container.addChild(mesh);
			mesh.rotation.x = Math.PI / 4;
			mesh.recompose();
			
			camera.position.z = -200;
			camera.recompose();
		}
		
		override public function loop():void {
			view.diagram.message = "Objects: " + process0.numObjects + "/" + process0.container.numChildren;
		}
		
	}

}