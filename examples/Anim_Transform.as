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
	 * You may want to check out Anim_Texure first.
	 * 变换动画
	 * 建议您先看Anim_Texure那个例子
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
			
			// In this chapter, we'll learn to create an AnimationTrack that stores TransformKeyFrames.
			// 这个例子，我们学习手动建立存放TransformKeyFrame列表的AnimationTrack。
			var track:AnimationTrack = new AnimationTrack();
			// First, we value it's modifier, it important.
			// 首先，我们给modifier赋值，这非常重要。
			track.modifier = new TransformModifier();
			// We set track's start time to 1.
			// 我们将此track开始的时间改为1，相当于一个延迟效果。
			track.start = 1;
			
			mesh.tracks = new Vector.<AnimationTrack>();
			mesh.tracks.push(track);
			
			// We create a new KeyFrame, then we can set it's time, position, rotation, scale value. Then we push it to our track.
			// 新建关键帧，我们可以设置时间，所进行的变换（位置，旋转，缩放），然后将其加入到track中。
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
			
			// At last, just link the mesh to our controller and we are done ;)
			// 最后，连接到我们的控制器就行了。
			anim_controller = new AnimationController();
			anim_controller.objects.push(mesh);
			anim_controller.loops = int.MAX_VALUE;
			anim_controller.restart();
			
			camera.position.z = -200;
			camera.recompose();
		}
		
		override public function loop():void {
			anim_controller.calculate();
			view.diagram.message = anim_controller.time.toFixed(2);
		}
		
	}

}