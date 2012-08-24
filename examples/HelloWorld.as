package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.CameraController;
	import nest.control.GlobalMethods;
	import nest.object.Container3D;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.culls.BasicCulling;
	import nest.view.lights.AmbientLight;
	import nest.view.lights.DirectionalLight;
	import nest.view.managers.BasicManager;
	import nest.view.materials.ColorMaterial;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * HelloWorld
	 */
	public class HelloWorld extends Sprite {
		
		private var controller:CameraController;
		
		public function HelloWorld() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			GlobalMethods.stage = stage;
			GlobalMethods.stage3d = stage.stage3Ds[0];
			GlobalMethods.camera = new Camera3D();
			GlobalMethods.root = new Container3D();
			GlobalMethods.manager = new BasicManager();
			GlobalMethods.view = new ViewPort(800, 600);
			GlobalMethods.view.culling = new BasicCulling();
			addChild(GlobalMethods.view.diagram);
			
			controller = new CameraController();
			controller.mouseEnabled = true;
			controller.keyboardEnabled = true;
			controller.speed = 10;
			
			GlobalMethods.view.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
		}
		
		private function onContext3DCreated(e:Event):void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var data:MeshData = PrimitiveFactory.createBox();
			var material:ColorMaterial = new ColorMaterial(0xffffff);
			material.light = new AmbientLight();
			material.light.next = new DirectionalLight(0xffffff, -1, -1);
			material.update();
			
			var mesh:Mesh = new Mesh(data, material);
			GlobalMethods.root.addChild(mesh);
			
			GlobalMethods.camera.position.z = -200;
			GlobalMethods.camera.changed = true;
		}
		
		private function onResize(e:Event):void {
			GlobalMethods.view.width = stage.stageWidth;
			GlobalMethods.view.height = stage.stageHeight;
		}
		
		private function onEnterFrame(e:Event):void {
			controller.update();
			GlobalMethods.view.calculate();
		}
		
	}

}