package  
{
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DTriangleFace;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nest.view.managers.BasicManager;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.CameraController;
	import nest.control.GlobalMethods;
	import nest.object.data.MeshData;
	import nest.object.Container3D;
	import nest.object.Mesh;
	import nest.view.materials.TextureMaterial;
	import nest.view.Camera3D;
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
			super();
		}
		
		override public function init():void {
			GlobalMethods.manager = manager = new BasicManager(); 
			var data:MeshData = PrimitiveFactory.createSphere(10);
			var material:TextureMaterial = new TextureMaterial(new diffuse().bitmapData);
			material.update();
			var material1:TextureMaterial = new TextureMaterial(new diffuse1().bitmapData);
			material1.update();
			
			var mesh:Mesh;
			var i:int, j:int, k:int;
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					for (k = 0; k < 10; k++) {
						if (k < 5) {
							mesh = new Mesh(data, material);
							mesh.culling = Context3DTriangleFace.NONE;
							mesh.blendMode.source = Context3DBlendFactor.SOURCE_ALPHA;
							mesh.blendMode.dest = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
							mesh.alphaTest = true;
						} else {
							mesh = new Mesh(data, material1);
						}
						mesh.position.setTo(i * 40, j * 40, k * 40);
						mesh.changed = true;
						scene.addChild(mesh);
					}
				}
			}
			
			camera.position.z = -20;
			camera.changed = true;
		}
		
	}

}