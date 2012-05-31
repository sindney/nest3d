package  
{
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.effects.Outline;
	import nest.view.lights.AmbientLight;
	import nest.view.materials.ColorMaterial;
	import nest.view.Shader3D;
	
	/**
	 * OutlineDemo
	 */
	public class OutlineDemo extends DemoBase {
		
		public function OutlineDemo() {
			super();
		}
		
		override public function init():void {
			view.lights[0] = new AmbientLight();
			view.effect = new Outline(0.6);
			view.color = 0xCCCCCC;
			
			var data:MeshData = PrimitiveFactory.createSphere(100, 32, 24);
			
			var colorMat:ColorMaterial = new ColorMaterial(0xffffff);
			
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, false, false, view.lights, view.effect);
			
			var mesh:Mesh = new Mesh(data, colorMat, shader);
			scene.addChild(mesh);
			
			speed = 10;
			camera.position.z = -300;
			camera.changed = true;
		}
		
	}

}