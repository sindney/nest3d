package  
{
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DTriangleFace;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.MeshData;
	import nest.object.Container3D;
	import nest.object.Mesh;
	import nest.view.managers.AlphaManager;
	import nest.view.materials.TextureMaterial;
	import nest.view.Camera3D;
	import nest.view.Shader3D;
	import nest.view.ViewPort;
	
	/**
	 * AlphaTestDemo
	 */
	public class AlphaTestDemo extends DemoBase {
		
		[Embed(source = "assets/box.jpg")]
		private const diffuse1:Class;
		
		[Embed(source = "assets/leaves.png")]
		private const diffuse:Class;
		
		public function AlphaTestDemo() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			camera = new Camera3D();
			scene = new Container3D();
			manager = new AlphaManager();
			view = new ViewPort(800, 600, stage.stage3Ds[0], camera, scene, manager);
			
			controller = new ObjectController(camera, stage);
			
			init();
			
			addChild(view.diagram);
			
			view.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
		}
		
		override public function init():void {
			var data:MeshData = PrimitiveFactory.createSphere(10);
			var material:TextureMaterial = new TextureMaterial(new diffuse().bitmapData);
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, true);
			
			var material1:TextureMaterial = new TextureMaterial(new diffuse1().bitmapData);
			
			var mesh:Mesh;
			var i:int, j:int, k:int;
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					for (k = 0; k < 10; k++) {
						if (k < 5) {
							mesh = new Mesh(data, material, shader);
							mesh.culling = Context3DTriangleFace.NONE;
							mesh.blendMode.source = Context3DBlendFactor.SOURCE_ALPHA;
							mesh.blendMode.dest = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
							mesh.alphaTest = true;
						} else {
							mesh = new Mesh(data, material1, shader);
						}
						mesh.position.setTo(i * 40, j * 40, k * 40);
						mesh.changed = true;
						scene.addChild(mesh);
					}
				}
			}
			
			speed = 10;
			camera.position.z = -20;
			camera.changed = true;
		}
		
	}

}