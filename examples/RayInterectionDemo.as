package  
{
	import flash.geom.Vector3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.IntersectionData;
	import nest.object.data.*;
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.geom.Intersection;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	public class RayInterectionDemo extends DemoBase {
		
		public function RayInterectionDemo() {
			super();
		}
		
		private var box:Mesh;
		private var spot:Mesh;
		
		override public function init():void {
			view.light = new AmbientLight(0x333333);
			view.light.next = new DirectionalLight(0xffffff, -1.414, -1.414, 0);
			
			var data:MeshData = PrimitiveFactory.createBox(20, 20, 20);
			
			var colorMat:ColorMaterial = new ColorMaterial(0xff0000);
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, false, false, false, view.light);
			
			box = new Mesh(data, colorMat, shader);
			scene.addChild(box);
			
			data = PrimitiveFactory.createSphere(1, 8, 8);
			
			colorMat = new ColorMaterial(0xffffff);
			
			spot = new Mesh(data, colorMat, shader);
			scene.addChild(spot);
			
			speed = 10;
			camera.position.z = -40;
			camera.changed = true;
		}
		
		override public function loop():void {
			camera.recompose();
			box.recompose();
			var orgion:Vector3D = box.matrix.transformVector(camera.position);
			var delta:Vector3D = box.matrix.transformVector(camera.matrix.transformVector(new Vector3D(0, 0, 200)));
			
			var result:IntersectionData = new IntersectionData();
			
			Intersection.Ray_Mesh(result, orgion, delta, box);
			
			spot.position.copyFrom(result.point);
			spot.changed = true;
		}
		
	}

}