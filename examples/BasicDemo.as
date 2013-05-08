package  
{
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.util.Primitives;
	import nest.control.partition.OcNode;
	import nest.control.partition.OcTree;
	import nest.object.geom.Bound;
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
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var geom:Geometry = Primitives.createBox();
			Geometry.setupGeometry(geom, true, false, false, false);
			Geometry.uploadGeometry(geom, true, false, false, false, true);
			Geometry.calculateBound(geom);
			
			var shader:Shader3D = new Shader3D();
			shader.constantsPart.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 1])));
			shader.comply("m44 vt0, va0, vc0\nm44 op, vt0, vc4\n", "mov oc, fc0\n");
			
			var shaders:Vector.<Shader3D> = Vector.<Shader3D>([shader]);
			var mesh:Mesh;
			
			var i:int, j:int, k:int, l:int = 15, m:int = l * 25;
			for (i = 0; i < l; i++) {
				for (j = 0; j < l; j++) {
					for (k = 0; k < l; k++) {
						mesh = new Mesh(geom, shaders);
						mesh.position.setTo(i * 50 - m, j * 50 - m, k * 50 - m);
						mesh.scale.setTo(10, 10, 10);
						container.addChild(mesh);
					}
				}
			}
			
			container.partition = new OcTree();
			//container.partition.frustum = true;
			(container.partition as OcTree).create(container, 4, l * 50);
			
			camera.recompose();
		}
		
	}

}