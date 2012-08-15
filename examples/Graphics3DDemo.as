package  
{
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.MeshData;
	import nest.object.Graphics3D;
	import nest.object.Mesh;
	import nest.view.lights.AmbientLight;
	import nest.view.lights.PointLight;
	import nest.view.materials.ColorMaterial;
	import nest.view.Shader3D;
	
	/**
	 * Graphics3DDemo
	 */
	public class Graphics3DDemo extends DemoBase {
	
		private var graphics3D:Graphics3D;
		
		public function Graphics3DDemo() {
			super();
		}
		
		override public function init():void {
			graphics3D = new Graphics3D();
			addChild(graphics3D.canvas);
			scene.addChild(graphics3D);
			
			graphics3D.lineStyle(0, 0xff0000);
			graphics3D.drawRect( -10, -10, 0, 20, 20);
			graphics3D.moveTo(-10, 0,0);
			graphics3D.lineTo(10, 0,0);
			graphics3D.lineStyle(0, 0x00ff00);
			graphics3D.rotateGraphics(90, 0, 0);
			graphics3D.drawRect( -10, -10, 0, 20, 20);
			graphics3D.moveTo(0, -10,0);
			graphics3D.lineTo(0, 10,0);
			graphics3D.clearGraphics();
			graphics3D.rotateGraphics(0, 90, 0);
			graphics3D.lineStyle(0, 0x0000ff);
			graphics3D.drawRect( -10, -10, 0, 20, 20);
			graphics3D.moveTo(0, -10,0);
			graphics3D.lineTo(0, 10,0);
			
			camera.position.z = -40;
			camera.changed = true;
			
			controller.speed = 2;
		}
	}

}