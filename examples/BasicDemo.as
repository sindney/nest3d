package  
{
	import flash.display3D.Context3DProgramType;
	
	import nest.control.util.Primitives;
	import nest.control.partition.OcNode;
	import nest.control.partition.OcTree;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.shader.*;
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
			process0.meshProcess = new BasicMeshProcess();
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var geom:Geometry = Primitives.createBox();
			Geometry.setupGeometry(geom, true, false, false);
			Geometry.uploadGeometry(geom, true, false, false, true);
			
			var shader:Shader3D = new Shader3D();
			shader.constantParts.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 1])));
			shader.comply("m44 vt0, va0, vc0\nm44 vt0, vt0, vc4\n" + 
							"m44 op, vt0, vc8\n",
							"mov oc, fc0\n");
			
			var mesh:Mesh;
			
			var offsetX:Number = 0, offsetY:Number = 0, offsetZ:Number = 0;
			
			var i:int, j:int, k:int, l:int = 15, m:int = l * 25;
			for (i = 0; i < l; i++) {
				for (j = 0; j < l; j++) {
					for (k = 0; k < l; k++) {
						mesh = new Mesh(geom, null, shader);
						mesh.position.setTo(i * 50 - m + offsetX, j * 50 - m + offsetY, k * 50 - m + offsetZ);
						mesh.scale.setTo(10, 10, 10);
						container.addChild(mesh);
					}
				}
			}
			
			container.partition = new OcTree();
			(container.partition as OcTree).create(container, 4, l * 50, offsetX, offsetY, offsetZ);
			
			camera.position.z = -200;
			camera.recompose();
		}
		
		override public function loop():void {
			view.diagram.message = "Objects: " + process0.numObjects + "/" + process0.container.numChildren + 
									"\nVertices: " + process0.numVertices + 
									"\nTriangles: " + process0.numTriangles;
		}
		
	}

}