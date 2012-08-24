package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import nest.control.CameraController;
	import nest.control.GlobalMethods;
	import nest.object.Container3D;
	import nest.view.culls.BasicCulling;
	import nest.view.managers.BasicManager;
	import nest.view.managers.ISceneManager;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * DemoBase
	 * 
	 * Y
	 * |     Z
	 * |    /
	 * |   /
	 * |  /
	 * | /
	 * |/__ _ _ _ _ X
	 * 
	 * Left Handed Crood SyS.
	 * 
	 * rx = pitch
	 * ry = yaw
	 * rz = roll
	 */
	public class DemoBase extends Sprite {
		
		protected var view:ViewPort;
		protected var camera:Camera3D;
		protected var scene:Container3D;
		protected var manager:ISceneManager;
		protected var controller:CameraController;
		
		protected var actived:Boolean = true;
		
		public function DemoBase() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			GlobalMethods.stage = stage;
			GlobalMethods.stage3d = stage.stage3Ds[0];
			GlobalMethods.camera = camera = new Camera3D();
			GlobalMethods.root = scene = new Container3D();
			GlobalMethods.manager = manager = new BasicManager();
			GlobalMethods.view = view = new ViewPort(800, 600);
			GlobalMethods.view.culling = new BasicCulling();
			addChild(view.diagram);
			
			controller = new CameraController();
			controller.mouseEnabled = true;
			controller.keyboardEnabled = true;
			controller.speed = 10;
			
			view.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
		}
		
		protected function onStageDeactived(e:Event):void {
			if (actived) {
				stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				view.diagram.message = "Paused ... ";
				actived = false;
			}
		}
		
		protected function onStageActived(e:Event):void {
			if (!actived) {
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				actived = true;
			}
		}
		
		protected function onRightClick(e:MouseEvent):void {
			
		}
		
		protected function onContext3DCreated(e:Event):void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.ACTIVATE, onStageActived);
			stage.addEventListener(Event.DEACTIVATE, onStageDeactived);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			init();
			view.calculate();
		}
		
		public function init():void {
			
		}
		
		public function loop():void {
			
		}
		
		protected function onResize(e:Event):void {
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
		protected function onEnterFrame(e:Event):void {
			controller.update();
			loop();
			view.calculate();
			view.diagram.message = "Objects: " + manager.numObjects + "\nTriangles: " + manager.numTriangles + "\nVertices: " + manager.numVertices;
		}
		
	}

}