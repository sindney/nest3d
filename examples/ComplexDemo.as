package  
{
	import flash.display3D.Context3DTextureFormat;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.VertexKeyFrame;
	import nest.control.animation.VertexModifier;
	import nest.control.animation.TransformKeyFrame;
	import nest.control.animation.TransformModifier;
	import nest.control.controller.AnimationController;
	import nest.control.factory.PrimitiveFactory;
	import nest.control.parser.ParserMD2;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.material.TextureMaterial;
	import nest.view.process.*;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * ComplexDemo
	 */
	public class ComplexDemo extends DemoBase {
		
		[Embed(source = "assets/marvin.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/marvin.md2", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var process0:ContainerProcess;
		private var process1:ContainerProcess;
		private var container0:Container3D;
		private var container1:Container3D;
		private var anim_controller:AnimationController;
		private var camera1:Camera3D;
		
		public function ComplexDemo() {
			super();
			
		}
		
		override public function init():void {
			container0 = new Container3D();
			container1 = new Container3D();
			
			camera1 = new Camera3D();
			camera1.position.y = -200;
			camera1.rotation.x = -Math.PI / 2;
			camera1.recompose();
			
			process0 = new ContainerProcess(camera1, container0);
			process0.meshProcess = new BasicMeshProcess(camera1);
			process0.color = 0xff0066ff;
			
			process1 = new ContainerProcess(camera, container1);
			process1.meshProcess = new BasicMeshProcess(camera);
			process1.color = 0xff000000;
			
			view.processes.push(process0, process1);
			
			var marvinSkin:TextureMaterial = new TextureMaterial(new diffuse().bitmapData);
			marvinSkin.comply();
			
			var parser:ParserMD2 = new ParserMD2();
			var marvin:Mesh = parser.parse(new model(), 1);
			marvin.tracks[0].modifier = new VertexModifier();
			marvin.material = marvinSkin;
			container0.addChild(marvin);
			container1.addChild(marvin);
			marvin.rotation.x = -Math.PI / 2;
			marvin.rotation.y = Math.PI / 2;
			marvin.recompose();
			
			var track:AnimationTrack = new AnimationTrack();
			track.modifier = new TransformModifier();
			track.start = 0;
			marvin.tracks.push(track);
			
			var keyFrame:TransformKeyFrame = new TransformKeyFrame();
			keyFrame.time = 0;
			keyFrame.position.x = 0;
			keyFrame.rotation.copyFrom(marvin.rotation);
			track.addChild(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 10;
			keyFrame.position.x = 20;
			keyFrame.rotation.copyFrom(marvin.rotation);
			track.addChild(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 30;
			keyFrame.position.x = -20;
			keyFrame.rotation.copyFrom(marvin.rotation);
			track.addChild(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 40;
			keyFrame.position.x = 0;
			keyFrame.rotation.copyFrom(marvin.rotation);
			track.addChild(keyFrame);
			
			anim_controller = new AnimationController();
			anim_controller.objects.push(marvin);
			anim_controller.loops = int.MAX_VALUE;
			anim_controller.speed = 10;
			anim_controller.restart();
			
			var groundSkin:TextureMaterial = new TextureMaterial(null);
			groundSkin.diffuse.texture = ViewPort.context3d.createTexture(512, 512, Context3DTextureFormat.BGRA, true);
			groundSkin.comply();
			var ground:Mesh = new Mesh(PrimitiveFactory.createPlane(200, 200, 10, 10), groundSkin);
			container1.addChild(ground);
			ground.position.y = -25;
			ground.recompose();
			
			process0.renderTarget.texture = groundSkin.diffuse.texture;
			
			camera.position.z = -200;
			camera.position.y = 100;
			camera.rotation.x = Math.PI / 6;
			camera.recompose();
		}
		
		override public function loop():void {
			anim_controller.calculate();
			view.diagram.message = "Time: " + anim_controller.time.toFixed(2) + "\nObjects:" + (process0.numObjects + process1.numObjects);
		}
		
	}

}