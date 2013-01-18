package  
{
	import flash.display3D.textures.Texture;
	
	import nest.control.factory.PrimitiveFactory;
	import nest.control.partition.OcNode;
	import nest.control.partition.OcTree;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.effect.RedBlueMap;
	import nest.view.material.ColorMaterial;
	import nest.view.process.*;
	
	/**
	 * BasicDemo
	 */
	public class BasicDemo extends DemoBase {
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		
		public function BasicDemo() {
			
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new BasicMeshProcess(camera);
			process0.color = 0xff000000;
			
			var effect:RedBlueMap = new RedBlueMap(512, 512, process0);
			effect.comply();
			
			process0.renderTarget.texture = effect.texture;
			
			view.processes.push(process0, effect);
			
			var geom:Geometry = PrimitiveFactory.createBox(1, 1, 1);
			var material:ColorMaterial = new ColorMaterial();
			material.comply();
			var mesh:Mesh;
			
			var offsetX:Number = 0, offsetY:Number = 0, offsetZ:Number = 0;
			
			var i:int, j:int, k:int, l:int = 13, m:int = l * 25;
			for (i = 0; i < l; i++) {
				for (j = 0; j < l; j++) {
					for (k = 0; k < l; k++) {
						mesh = new Mesh(geom, material);
						mesh.position.setTo(i * 50 - m + offsetX, j * 50 - m + offsetY, k * 50 - m + offsetZ);
						mesh.scale.setTo(10, 10, 10);
						container.addChild(mesh);
						mesh.recompose();
					}
				}
			}
			
			container.partition = new OcTree();
			(container.partition as OcTree).create(container, 4, l * 50, offsetX, offsetY, offsetZ);
			
			camera.recompose();
		}
		
		override public function loop():void {
			view.diagram.message = "Objects: " + process0.numObjects + "/" + process0.container.numChildren;
		}
		
	}

}