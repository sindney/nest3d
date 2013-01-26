package  
{
	import nest.control.factory.PrimitiveFactory;
	import nest.control.partition.OcNode;
	import nest.control.partition.OcTree;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.material.ColorMaterial;
	import nest.view.process.*;
	
	/**
	 * MouseEventDemo
	 */
	public class MouseEventDemo extends DemoBase {
		
		private var process0:MouseProcess;
		private var process1:ContainerProcess;
		private var container:Container3D;
		
		private var material0:ColorMaterial;
		private var material1:ColorMaterial;
		private var material2:ColorMaterial;
		
		public function MouseEventDemo() {
			
		}
		
		override public function init():void {
			container = new Container3D();
			
			process1 = new ContainerProcess(camera, container);
			process1.meshProcess = new BasicMeshProcess(camera);
			process1.color = 0xff000000;
			
			process0 = new MouseProcess(stage, process1);
			
			view.processes.push(process0, process1);
			
			material0 = new ColorMaterial();
			material0.comply();
			
			material1 = new ColorMaterial(0xffff0000);
			material1.comply();
			
			material2 = new ColorMaterial(0xff0000ff);
			material2.comply();
			
			var geom:Geometry = PrimitiveFactory.createBox(1, 1, 1);
			var mesh:Mesh;
			
			var offsetX:Number = 0, offsetY:Number = 0, offsetZ:Number = 0;
			
			var i:int, j:int, k:int, l:int = 13, m:int = l * 25;
			for (i = 0; i < l; i++) {
				for (j = 0; j < l; j++) {
					for (k = 0; k < l; k++) {
						mesh = new Mesh(geom, material0);
						mesh.position.setTo(i * 50 - m + offsetX, j * 50 - m + offsetY, k * 50 - m + offsetZ);
						mesh.scale.setTo(10, 10, 10);
						mesh.mouseEnabled = true;
						container.addChild(mesh);
						mesh.recompose();
						mesh.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseOver);
						mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
						mesh.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut);
					}
				}
			}
			
			container.partition = new OcTree();
			(container.partition as OcTree).create(container, 4, l * 50, offsetX, offsetY, offsetZ);
			
			camera.recompose();
		}
		
		private function onMouseOut(e:MouseEvent3D):void {
			(e.target as Mesh).material = material0;
		}
		
		private function onMouseDown(e:MouseEvent3D):void {
			(e.target as Mesh).material = material1;
		}
		
		private function onMouseOver(e:MouseEvent3D):void {
			(e.target as Mesh).material = material2;
		}
		
		override public function loop():void {
			view.diagram.message = "Objects: " + process1.numObjects + "/" + process1.container.numChildren + 
									"\nVertices: " + process1.numVertices + 
									"\nTriangles: " + process1.numTriangles;
		}
		
	}

}