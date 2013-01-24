package  
{
	import flash.display3D.Context3DTextureFormat;
	
	import nest.control.factory.PrimitiveFactory;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.Camera3D;
	import nest.view.light.AmbientLight;
	import nest.view.light.DirectionalLight;
	import nest.view.material.ColorMaterial;
	import nest.view.material.TextureMaterial;
	import nest.view.process.*;
	import nest.view.ViewPort;
	
	/**
	 * RenderToTexture
	 */
	public class RenderToTexture extends DemoBase {
		
		private var process0:ContainerProcess;
		private var process1:ContainerProcess;
		
		public function RenderToTexture() {
			
		}
		
		override public function init():void {
			var container0:Container3D = new Container3D();
			var container1:Container3D = new Container3D();
			
			var camera1:Camera3D = new Camera3D();
			
			process0 = new ContainerProcess(camera1, container0);
			process0.meshProcess = new BasicMeshProcess(camera1);
			process0.color = 0xff000000;
			
			process1 = new ContainerProcess(camera, container1);
			process1.meshProcess = new BasicMeshProcess(camera);
			process1.color = 0xffffffff;
			
			view.processes.push(process0, process1);
			
			mesh = new Mesh(PrimitiveFactory.createSphere(100, 16, 12), new ColorMaterial(0xff0066ff));
			(mesh.material as ColorMaterial).lights.push(new AmbientLight(0x333333), new DirectionalLight(0xffffff, 0.414, 0.414, 0.414));
			mesh.material.comply();
			container0.addChild(mesh);
			mesh.position.z = 400;
			mesh.recompose();
			
			var material:TextureMaterial = new TextureMaterial(null);
			material.diffuse.texture = ViewPort.context3d.createTexture(512, 512, Context3DTextureFormat.BGRA, true);
			material.comply();
			
			var mesh1:Mesh = new Mesh(PrimitiveFactory.createBox(), material);
			container1.addChild(mesh1);
			mesh1.rotation.x = Math.PI * 1.5;
			mesh1.position.z = 200;
			mesh1.recompose();
			
			process0.renderTarget.texture = material.diffuse.texture;
		}
		
		private var mesh:Mesh;
		
		override public function loop():void {
			view.diagram.message = "Objects: " + (process0.numObjects + process1.numObjects) + "/" + (process0.container.numChildren + process1.container.numChildren);
			mesh.rotation.y += 0.01;
			mesh.recompose();
		}
		
	}

}