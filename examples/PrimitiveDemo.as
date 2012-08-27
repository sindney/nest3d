package  
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import nest.control.factories.PrimitiveFactory;
	import nest.object.data.MeshData;
	import nest.object.geom.Vertex;
	import nest.object.Mesh;
	import nest.view.lights.AmbientLight;
	import nest.view.lights.DirectionalLight;
	import nest.view.materials.TextureMaterial;
	
	/**
	 * SphereDemo
	 */
	public class PrimitiveDemo extends DemoBase {
		
		[Embed(source = "assets/box.jpg")]
		private const bitmap:Class;
		
		public function PrimitiveDemo() {
			super();
		}
		
		override public function init():void {
			var light:AmbientLight = new AmbientLight(0x333333);
			light.next = new DirectionalLight();
			light.next.next = new DirectionalLight(0xffff00, -1, -1);
			
			var material:TextureMaterial = new TextureMaterial(new bitmap().bitmapData);
			material.light = light;
			material.update();
			
			var rad:Number = 0;
			var step:Number = Math.PI / 6;
			var radius:Number = 30;
			var origin:Vector3D = new Vector3D();
			
			var mesh:Mesh = new Mesh(PrimitiveFactory.createSphere(5, 20, 20), material);
			mesh.position.setTo(radius * Math.sin(rad), 0, radius*Math.cos(rad));
			mesh.lookAt(origin);
			scene.addChild(mesh);
			
			rad+=step;
			
			mesh = new Mesh(PrimitiveFactory.createBox(10, 10, 10), material);
			mesh.position.setTo(radius * Math.sin(rad), 0, radius*Math.cos(rad));
			mesh.lookAt(origin);
			scene.addChild(mesh);
			
			rad += step;
			
			mesh = new Mesh(PrimitiveFactory.createPlane(10, 10), material);
			mesh.position.setTo(radius * Math.sin(rad), 0, radius*Math.cos(rad));
			mesh.lookAt(origin);
			mesh.rotation.x = Math.PI / 2;
			mesh.changed = true;
			scene.addChild(mesh);
			
			rad += step;
			
			var cylinderSample:Vector.<Point> = new Vector.<Point>();
			var cylinderPath:Vector.<Vertex> = new Vector.<Vertex>();
			for (var i:int = 0; i < 21;i++ ) {
				cylinderSample.push(new Point(5 * Math.sin(i / 10 * Math.PI), 5 * Math.cos(i / 10 * Math.PI)));
				cylinderPath.push(new Vertex(0, -5 + i/2, 0));
			}
			mesh = new Mesh(PrimitiveFactory.createPrimitiveByLoft(cylinderSample,cylinderPath,true,true), material);
			mesh.position.setTo(radius * Math.sin(rad), 0, radius*Math.cos(rad));
			mesh.lookAt(origin);
			scene.addChild(mesh);
			
			rad += step;
			
			var donutSample:Vector.<Point> = new Vector.<Point>();
			for (i = 0; i < 21;i++ ) {
				donutSample.push(new Point(3 + 2 * Math.sin(i / 10 * Math.PI), 2 * Math.cos(i / 10 * Math.PI)));
			}
			mesh = new Mesh(PrimitiveFactory.createPrimitiveByRevolution(donutSample,20), material);
			mesh.position.setTo(radius * Math.sin(rad), 0, radius*Math.cos(rad));
			mesh.lookAt(origin);
			scene.addChild(mesh);
			
			rad += step;
			
			var sinPath:Vector.<Vertex> = new Vector.<Vertex>();
			for (var i:int = 0; i < 21;i++ ) {
				sinPath.push(new Vertex(Math.sin(i), -10+i, 0));
			}
			mesh = new Mesh(PrimitiveFactory.createPrimitiveByLoft(cylinderSample,sinPath,true,false), material);
			mesh.position.setTo(radius * Math.sin(rad), 0, radius*Math.cos(rad));
			mesh.lookAt(origin);
			scene.addChild(mesh);
			
			rad += step;
			
			var bottleSample:Vector.<Point> = Vector.<Point>([new Point(65, 0), new Point(30, -25),
															  new Point(25, -55), new Point(25, -70),
															  new Point(30, -85), new Point(85, -130),
															  new Point(75, -265), new Point(50, -350)]);
			mesh = new Mesh(PrimitiveFactory.createPrimitiveByRevolution(bottleSample, 20), material);
			mesh.scale.setTo(.05, .05, .05);
			mesh.position.setTo(radius * Math.sin(rad), 10, radius * Math.cos(rad));
			mesh.changed = true;
			scene.addChild(mesh);
			
			controller.speed = 1;
			camera.position.z = 0;
			camera.changed = true;
		}
		
	}

}