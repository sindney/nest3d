package  
{	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.mouse.MouseManager;
	import nest.control.mouse.MouseEvent3D;
	import nest.object.data.*;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	
	/**
	 * Mouse3DDemo
	 */
	public class Mouse3DDemo extends DemoBase {
		
		private var pointLight:PointLight;
		
		public function Mouse3DDemo() {
			super();
		}
		
		private var colorMat:ColorMaterial;
		private var colorMat1:ColorMaterial;
		private var colorMat2:ColorMaterial;
		
		override public function init():void {
			var light:AmbientLight = new AmbientLight(0x333333);
			light.next = pointLight = new PointLight(0xffffff, 200, 0, 0, 0);
			
			var data:MeshData = PrimitiveFactory.createBox(10, 10, 10);
			
			colorMat = new ColorMaterial(0xffffff);
			colorMat.light = light;
			colorMat.update();
			colorMat1 = new ColorMaterial(0x0066ff);
			colorMat1.light = light;
			colorMat1.update();
			colorMat2 = new ColorMaterial(0xff0000);
			colorMat2.light = light;
			colorMat2.update();
			
			var cube:Mesh;
			var i:int, j:int, k:int = 0;
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					for (k = 0; k < 10; k++) {
						cube = new Mesh(data, colorMat);
						cube.position.setTo(i * 40, j * 40, k * 40);
						cube.changed = true;
						cube.mouseEnabled = true;
						cube.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseOver);
						cube.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
						cube.addEventListener(MouseEvent3D.CLICK, onMouseUp);
						cube.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut);
						scene.addChild(cube);
					}
				}
			}
			
			view.mouseManager = new MouseManager();
			scene.mouseEnabled = true;
			
			camera.position.z = -20;
			camera.changed = true;
		}
		
		private function onMouseUp(e:MouseEvent3D):void {
			(e.target as Mesh).material = colorMat1;
		}
		
		private function onMouseOut(e:MouseEvent3D):void {
			(e.target as Mesh).material = colorMat;
		}
		
		private function onMouseOver(e:MouseEvent3D):void {
			(e.target as Mesh).material = colorMat1;
		}
		
		private function onMouseDown(e:MouseEvent3D):void {
			(e.target as Mesh).material = colorMat2;
		}
		
		override public function loop():void {
			pointLight.position[0] = camera.position.x;
			pointLight.position[1] = camera.position.y;
			pointLight.position[2] = camera.position.z;
		}
		
	}

}