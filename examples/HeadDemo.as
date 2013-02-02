package  
{
	import flash.display.BitmapData;
	
	import nest.control.factory.PrimitiveFactory;
	import nest.control.parser.Parser3DS;
	import nest.object.geom.Geometry;
	import nest.object.Container3D;
	import nest.object.Mesh;
	import nest.view.material.TextureMaterial;
	import nest.view.light.AmbientLight;
	import nest.view.light.DirectionalLight;
	import nest.view.process.BasicMeshProcess;
	import nest.view.process.ContainerProcess;
	
	/**
	 * HeadDemo
	 */
	public class HeadDemo extends DemoBase{
		
		[Embed(source = "assets/head_specular.jpg")]
		private const specular:Class;
		
		[Embed(source = "assets/head_diffuse.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/head_normals.jpg")]
		private const normals:Class;
		
		[Embed(source = "assets/head.3ds", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var mesh:Mesh;
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		
		public function HeadDemo() {
			super();
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new BasicMeshProcess(camera);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var parser:Parser3DS = new Parser3DS();
			parser.parse(new model(), 10);
			
			var material:TextureMaterial = new TextureMaterial(new diffuse().bitmapData, new specular().bitmapData, 40, new normals().bitmapData);
			material.lights.push(new AmbientLight(0x000000), new DirectionalLight(0xffffff, 0, 0, 1));
			material.comply();
			
			mesh = parser.objects[0];
			mesh.material = material;
			container.addChild(mesh);
			mesh.rotation.y = Math.PI;
			
			camera.position.z = -120;
			camera.recompose();
		}
		
		override public function loop():void {
			mesh.rotation.y += 0.01;
			mesh.recompose();
			view.diagram.message = "Objects: " + process0.numObjects + "/" + process0.container.numChildren + 
									"\nVertices: " + process0.numVertices + 
									"\nTriangles: " + process0.numTriangles;
		}
		
	}

}