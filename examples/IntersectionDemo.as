package  
{
	import flash.geom.Vector3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.object.data.*;
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.geom.Intersection;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	import nest.view.Shader3D;
	
	/**
	 * IntersectionDemo
	 */
	public class IntersectionDemo extends DemoBase {
		
		public function IntersectionDemo() {
			super();
		}
		
		private var box:Mesh;
		private var sphere:Mesh;
		private var hit:ColorMaterial;
		private var free:ColorMaterial;
		
		override public function init():void {
			var light:AmbientLight = new AmbientLight(0x333333);
			light.next = new PointLight(0xffffff, 200, 0, 0, 0);
			
			hit = new ColorMaterial(0xffff00);
			hit.light = light;
			hit.update();
			
			free = new ColorMaterial(0x00ff00);
			free.light = light;
			free.update();
			
			box = new Mesh(PrimitiveFactory.createBox(10, 10, 10), free);
			box.position.z = 40;
			box.changed = true;
			scene.addChild(box);
			
			sphere = new Mesh(PrimitiveFactory.createSphere(10, 20, 20), free, new BSphere());
			sphere.position.x = -20;
			sphere.position.z = 40;
			sphere.changed = true;
			scene.addChild(sphere);
			
			controller.speed = 1;
		}
		
		private var count:int = 0;
		private var state:Boolean = true;
		
		override public function loop():void {
			sphere.position.x += state ? 0.1 : -0.1;
			sphere.changed = true;
			
			if (count < 100) count++;
			if (count == 100) {
				count = 0;
				state = !state;
			}
			
			if (Intersection.AABB_BSphere((box.bound as AABB).max, (box.bound as AABB).min, box.invertMatrix.transformVector(sphere.matrix.transformVector(sphere.bound.center)), (sphere.bound as BSphere).radius)) {
				sphere.material = hit;
			} else {
				sphere.material = free;
			}
		}
		
	}

}