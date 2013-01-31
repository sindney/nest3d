package  
{
	import flash.display3D.Context3DTriangleFace;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.TextureKeyFrame;
	import nest.control.animation.TextureModifier;
	import nest.control.controller.AnimationController;
	import nest.control.factory.PrimitiveFactory;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.material.TextureMaterial;
	import nest.view.process.*;
	
	/**
	 * Anim_Texture
	 */
	public class Anim_Texture extends DemoBase {
		
		[Embed(source = "assets/sprite_sheet.png")]
		private var data:Class;
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		private var anim_controller:AnimationController;
		private var modifier:TextureModifier;
		
		public function Anim_Texture() {
			
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new BasicMeshProcess(camera);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			modifier = new TextureModifier();
			var track:AnimationTrack = modifier.getFromSpriteSheet(new data().bitmapData, 96, 128, 10, 19);
			track.modifier = modifier;
			
			var geom:Geometry = PrimitiveFactory.createPlane();
			var material:TextureMaterial = new TextureMaterial((track.first as TextureKeyFrame).diffuse);
			material.kill = 1;
			material.comply();
			
			var mesh:Mesh = new Mesh(geom, material);
			container.addChild(mesh);
			mesh.rotation.x = Math.PI / 2;
			mesh.triangleCulling = Context3DTriangleFace.NONE;
			mesh.recompose();
			
			mesh.tracks = new Vector.<AnimationTrack>();
			mesh.tracks.push(track);
			
			anim_controller = new AnimationController();
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