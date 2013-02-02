package  
{
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.VertexKeyFrame;
	import nest.control.animation.VertexModifier;
	import nest.control.controller.AnimationController;
	import nest.control.parser.ParserMD2;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.light.AmbientLight;
	import nest.view.light.DirectionalLight;
	import nest.view.material.TextureMaterial;
	import nest.view.process.*;
	
	/**
	 * Anim_Vertex
	 * You may want to check out Anim_Texure first.
	 * 顶点动画
	 * 建议您先看Anim_Texure那个例子
	 */
	public class Anim_Vertex extends DemoBase {
		
		[Embed(source = "assets/marvin.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/marvin.md2", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		private var anim_controller:AnimationController;
		
		public function Anim_Vertex() {
			super();
			
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new BasicMeshProcess(camera);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var material:TextureMaterial = new TextureMaterial(new diffuse().bitmapData);
			material.lights.push(new AmbientLight(0x000000), new DirectionalLight(0xffffff, 0, 0, 1));
			material.comply();
			
			// We demostrate vertex animation with a MD2 model.
			// 我们用一个MD2模型来演示顶点动画
			var parser:ParserMD2 = new ParserMD2();
			var mesh:Mesh = parser.parse(new model(), 1);
			mesh.tracks[0].modifier = new VertexModifier();
			mesh.material = material;
			container.addChild(mesh);
			mesh.rotation.x = -Math.PI / 2;
			mesh.rotation.y = Math.PI / 2;
			mesh.recompose();
			
			anim_controller = new AnimationController();
			anim_controller.objects.push(mesh);
			anim_controller.loops = int.MAX_VALUE;
			anim_controller.speed = 10;
			anim_controller.restart();
			
			camera.position.z = -100;
			camera.recompose();
		}
		
		override public function loop():void {
			anim_controller.calculate();
			view.diagram.message = anim_controller.time.toFixed(2);
		}
		
	}

}