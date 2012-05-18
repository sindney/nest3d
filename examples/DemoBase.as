package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import nest.object.Container3D;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	import bloom.core.ThemeBase;
	import bloom.themes.BlueTheme;
	
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
		
		protected var keys:Array = new Array();
		
		protected var view:ViewPort;
		protected var camera:Camera3D;
		protected var scene:Container3D;
		
		protected var controller:ObjectController;
		
		protected var speed:Number = 2;
		
		public function DemoBase() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			camera = new Camera3D();
			scene = new Container3D();
			view = new ViewPort(800, 600, stage.stage3Ds[0], camera, scene);
			
			controller = new ObjectController(camera, stage);
			
			ThemeBase.initialize(stage);
			ThemeBase.theme = new BlueTheme();
			
			init();
			
			addChild(view.diagram);
			
			view.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
		}
		
		private function onRightClick(e:MouseEvent):void {
			
		}
		
		private function onContext3DCreated(e:Event):void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function init():void {
			
		}
		
		public function loop():void {
			
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			keys[e.keyCode] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			keys[e.keyCode] = false;
		}
		
		private function onResize(e:Event):void {
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
		protected function onEnterFrame(e:Event):void {
			if (keys[87]) camera.translate(Vector3D.Z_AXIS, speed);
			if (keys[83]) camera.translate(Vector3D.Z_AXIS, -speed);
			if (keys[68]) camera.translate(Vector3D.X_AXIS, speed);
			if (keys[65]) camera.translate(Vector3D.X_AXIS, -speed);
			
			loop();
			
			view.calculate();
			view.diagram.message = "Objects: " + view.numObjects + "\nTriangles: " + view.numTriangles + "\nVertices: " + view.numVertices;
		}
		
	}

}