package  
{
	import flash.display3D.Context3DTriangleFace;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.TextureKeyFrame;
	import nest.control.animation.TextureModifier;
	import nest.control.controller.AnimationController;
	import nest.control.factory.PrimitiveFactory;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.material.TextureMaterial;
	import nest.view.process.*;
	
	/**
	 * Anim_Texture
	 * 材质动画例子
	 */
	public class Anim_Texture extends DemoBase {
		
		[Embed(source = "assets/sprite_sheet.png")]
		private var data:Class;
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		private var anim_controller:AnimationController;
		
		public function Anim_Texture() {
			
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new BasicMeshProcess(camera);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			// AnimationTrack contains KeyFrames.
			// For Texture animations, you can get target AnimationTrack by TextureModifier's getFromSpriteSheet() && getFromMovieClip().
			// And remember, you will only need one Modifier instance.
			// AnimationTrack由IKeyFrame链表组成
			// 对于材质动画，我们可以从TextureModifier的getFromSpriteSheet() && getFromMovieClip()函数得到对应的Track。
			// 记住，对于使用相同KeyFrame类的Track，你只需要一个Modifier实例。
			var modifier:TextureModifier = new TextureModifier();
			var track:AnimationTrack = modifier.getFromSpriteSheet(new data().bitmapData, 96, 128, 0, 10);
			// Don't forget to value track.modifier.
			// 别忘了给track.modifier赋值。
			track.modifier = modifier;
			
			// We init TextureMaterial with the first KeyFrame form that track.
			// 我们用track的第一帧信息来初始化材质。
			var material:TextureMaterial = new TextureMaterial((track.first as TextureKeyFrame).diffuse);
			// We set kill command to 1, so any pixel who's alpha value is less than 1 will be ignored when rendering.
			// 设置材质的kill变量为1，这样，所有透明度小于1的像素在渲染时就会被忽略掉。
			material.kill = 1;
			// Then we comply the shader for our material.
			// 然后我们生成材质的着色器
			material.comply();
			
			// We init our mesh's geometry with a XYPlane, which stores as a static value in nest.control.factory.PrimitiveFactory.
			// 我们用XY平面来初始化Mesh的geometry，他来自nest.control.factory.PrimitiveFactory。
			var mesh:Mesh = new Mesh(PrimitiveFactory.sprite3d, material);
			container.addChild(mesh);
			// Set ignore rotation to true, so our mesh will always face to the camera.
			// 设置ignoreRotation为真，这样这个Mesh就永远朝向摄像机了。
			mesh.ignoreRotation = true;
			// Change mesh's transform matrix.
			// 修改Mesh的本地矩阵
			mesh.scale.setTo(100, 100, 100);
			// Then recompose the matrix. Remember, always call recompose() after mesh has a parent.
			// 然后重新生成矩阵，记住，一定在Mesh有parent之后再调用此函数。
			mesh.recompose();
			
			// We create the AnimationTrack array for our mesh and push the texture track in it.
			// 我们建立AnimationTrack数组，并存放之前的track。
			mesh.tracks = new Vector.<AnimationTrack>();
			mesh.tracks.push(track);
			
			// Start our controller
			anim_controller = new AnimationController();
			// Push our mesh to controller.objects, so he can controller our mesh.
			// 把Mesh放到controller的物体数组里，这样，我们的控制器就能控制他了。
			anim_controller.objects.push(mesh);
			anim_controller.loops = int.MAX_VALUE;
			anim_controller.speed = 20;
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