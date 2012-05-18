package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	import nest.control.factories.ShaderFactory;
	import nest.control.parsers.OBJParser;
	import nest.object.data.MeshData;
	import nest.object.Container3D;
	import nest.object.Mesh;
	import nest.object.Sound3D;
	import nest.view.lights.AmbientLight;
	import nest.view.lights.DirectionalLight;
	import nest.view.materials.TextureMaterial;
	import nest.view.materials.ColorMaterial;
	import nest.view.Camera3D;
	import nest.view.Shader3D;
	import nest.view.ViewPort;
	
	/**
	 * PlanetDemo
	 */
	public class PlanetDemo extends Sprite {
		
		[Embed(source = "assets/wind.mp3")]
		public const wind:Class;
		
		[Embed(source = "assets/earth.jpg")]
		private const bitmap:Class;
		
		[Embed(source = "assets/planet_compressed.obj", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var view:ViewPort;
		private var camera:Camera3D;
		private var scene:Container3D;
		
		private var planet:Mesh;
		private var light:DirectionalLight;
		private var direction:Vector3D;
		
		private var container:Container3D;
		
		public function PlanetDemo() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			direction = new Vector3D();
			
			camera = new Camera3D();
			scene = new Container3D();
			view = new ViewPort(800, 600, stage.stage3Ds[0], camera, scene);
			
			addChild(view.diagram);
			
			init();
			
			view.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
		}
		
		private function onRightClick(e:MouseEvent):void {
			
		}
		
		private function init():void {
			view.lights[0] = new AmbientLight(0x222222);
			view.lights[1] = light = new DirectionalLight();
			
			var parser:OBJParser = new OBJParser();
			var byte:ByteArray = new model();
			byte.uncompress();
			var data:MeshData = parser.parse(byte);
			
			var shader:Shader3D = new Shader3D(true, true);
			ShaderFactory.create(shader, view.lights);
			
			var colorShader:Shader3D = new Shader3D(false);
			ShaderFactory.create(colorShader);
			
			container = new Container3D();
			scene.addChild(container);
			
			planet = new Mesh(data, new TextureMaterial(new bitmap().bitmapData), shader);
			container.addChild(planet);
			
			var sun:Mesh = new Mesh(data, new ColorMaterial(0xffff00), colorShader);
			sun.position.z = 200;
			sun.scale.setTo(4, 4, 4);
			sun.changed = true;
			container.addChild(sun);
			
			var sound:Sound3D = new Sound3D(new wind() as Sound);
			sound.position.z = 200;
			sound.far = 600;
			sound.volumn = 0.5;
			sound.play(1000);
			container.addChild(sound);
			
			var i:int;
			var star:Mesh;
			var starMat:ColorMaterial = new ColorMaterial();
			for (i = 0; i < 500; i++) {
				star = new Mesh(data, starMat, colorShader);
				star.position.x = Math.random() * 5000 - Math.random() * 5000;
				star.position.y = Math.random() * 2000 - Math.random() * 2000;
				star.position.z = Math.random() * 5000 - Math.random() * 5000;
				star.scale.setTo(0.4, 0.4, 0.4);
				star.changed = true;
				container.addChild(star);
			}
			
			camera.position.z = -100;
			camera.changed = true;
		}
		
		private function onContext3DCreated(e:Event):void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onResize(e:Event):void {
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
		protected function onEnterFrame(e:Event):void {
			if (container.rotation.y > Math.PI * 2) container.rotation.y = 0;
			container.rotation.y += 0.001;
			container.changed = true;
			if (planet.rotation.y < 0) planet.rotation.y = Math.PI * 2;
			planet.rotation.y -= 0.01;
			planet.changed = true;
			
			direction.setTo(0, 0, 200);
			direction = container.matrix.transformVector(direction);
			direction.normalize();
			
			light.direction[0] = direction.x;
			light.direction[1] = direction.y;
			light.direction[2] = direction.z;
			
			view.calculate();
			view.diagram.message = "Objects: " + view.numObjects + "\nTriangles: " + view.numTriangles + "\nVertices: " + view.numVertices;
		}
		
	}

}