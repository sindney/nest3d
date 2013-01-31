package  
{
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.TransformKeyFrame;
	import nest.control.animation.TransformModifier;
	import nest.control.controller.AnimationController;
	import nest.control.factory.PrimitiveFactory;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.material.ColorMaterial;
	import nest.view.process.*;
	
	/**
	 * Anim_Transform
	 */
	public class Anim_Transform extends DemoBase {
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		private var anim_controller:AnimationController;
		
		public function Anim_Transform() {
			
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new BasicMeshProcess(camera);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var geom:Geometry = PrimitiveFactory.createBox(10, 10, 10);
			var material:ColorMaterial = new ColorMaterial(0xffffffff);
			material.comply();
			var mesh:Mesh = new Mesh(geom, material);
			container.addChild(mesh);
			
			var track:AnimationTrack = new AnimationTrack();
			track.modifier = new TransformModifier();
			track.start = 1;
			
			mesh.tracks = new Vector.<AnimationTrack>();
			mesh.tracks.push(track);
			
			var keyFrame:TransformKeyFrame = new TransformKeyFrame();
			keyFrame.time = 0;
			keyFrame.position.x = 0;
			keyFrame.scale.setTo(1, 1, 1);
			track.addChild(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 1;
			keyFrame.position.x = 100;
			keyFrame.scale.setTo(1, 10, 1);
			track.addChild(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 3;
			keyFrame.position.x = -100;
			keyFrame.scale.setTo(1, 10, 1);
			track.addChild(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 4;
			keyFrame.position.x = 0;
			keyFrame.scale.setTo(1, 1, 1);
			track.addChild(keyFrame);
			
			anim_controller = new AnimationController();
			anim_controller.objects.push(mesh);
			anim_controller.loops = 0;
			anim_controller.restart();
			
			camera.position.z = -200;
			camera.recompose();
		}
		
		override public function loop():void {
			anim_controller.calculate();
			view.diagram.message = anim_controller.time.toString();
		}
		
	}

}