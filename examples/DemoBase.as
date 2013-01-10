package  
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import nest.control.controller.CameraController;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * DemoBase
	 */
	public class DemoBase extends Sprite {
		
		protected var stage3d:Stage3D;
		
		protected var view:ViewPort;
		protected var camera:Camera3D;
		protected var controller:CameraController;
		
		protected var actived:Boolean = true;
		
		public function DemoBase() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			stage3d = stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			stage3d.requestContext3D();
		}
		
		protected function onContext3DCreated(e:Event):void {
			stage3d.removeEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			
			var context3d:Context3D = stage3d.context3D;
			
			context3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0);
			context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3d.setDepthTest(true, Context3DCompareMode.LESS);
			
			view = new ViewPort(context3d);
			addChild(view.diagram);
			
			camera = new Camera3D();
			
			controller = new CameraController(stage, camera);
			controller.keyboardEnabled = true;
			controller.mouseEnabled = true;
			controller.speed = 10;
			
			init();
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.ACTIVATE, onStageActived);
			stage.addEventListener(Event.DEACTIVATE, onStageDeactived);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
		
		public function init():void {
			
		}
		
		public function loop():void {
			
		}
		
		protected function onResize(e:Event):void {
			view.context3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0);
			camera.aspect = stage.stageWidth / stage.stageHeight;
			camera.update();
		}
		
		protected function onEnterFrame(e:Event):void {
			controller.calculate();
			loop();
			view.calculate();
		}
		
	}

}