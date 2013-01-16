package  
{
	import nest.control.factory.PrimitiveFactory;
	import nest.control.partition.QuadTree;
	import nest.object.geom.AABB;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
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
			
			view.processes.push(process0);
			
			var geom:Geometry = PrimitiveFactory.createBox(1, 1, 1);
			var material:ColorMaterial = new ColorMaterial();
			material.comply();
			var mesh:Mesh;
			
			var i:int, j:int, k:int = 70, l:int = k * 25;
			for (i = 0; i < k; i++) {
				for (j = 0; j < k; j++) {
					mesh = new Mesh(geom, material);
					mesh.position.setTo(i * 50 - l, 0, j * 50 - l);
					mesh.scale.setTo(10, 10, 10);
					container.addChild(mesh);
					mesh.recompose();
				}
			}
			
			container.partition = new QuadTree();
			(container.partition as QuadTree).create(container, 5, k * 50);
			
			camera.recompose();
		}
		
		override public function loop():void {
			view.diagram.message = "Objects: " + process0.numObjects + "/" + process0.container.numChildren;
		}
		
	}

}