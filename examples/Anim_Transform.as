package  
{
	import flash.display3D.Context3DProgramType;
	import flash.geom.Orientation3D;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.IKeyFrame;
	import nest.control.animation.TransformKeyFrame;
	import nest.control.animation.TransformModifier;
	import nest.control.controller.AnimationController;
	import nest.control.util.Primitives;
	import nest.control.util.Quaternion;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.process.*;
	import nest.view.shader.Shader3D;
	import nest.view.shader.VectorShaderPart;
	
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
			process0.meshProcess = new BasicMeshProcess();
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var geom:Geometry = Primitives.box;
			Geometry.setupGeometry(geom, true, false, false);
			Geometry.uploadGeometry(geom, true, false, false, true);
			var shader:Shader3D = new Shader3D();
			shader.constantParts.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 1])));
			shader.comply("m44 vt0, va0, vc0\nm44 vt0, vt0, vc4\n" + 
							"m44 op, vt0, vc8\n",
							"mov oc, fc0\n");
			var mesh:Mesh = new Mesh(geom, null, shader);
			mesh.orientation = Orientation3D.QUATERNION;
			mesh.rotation.w = 1;
			mesh.scale.setTo(10, 10, 10);
			container.addChild(mesh);
			
			var track:AnimationTrack = new AnimationTrack();
			track.frames = new Vector.<IKeyFrame>();
			track.modifier = new TransformModifier();
			track.target = mesh;
			track.position = 1;
			track.enabled = true;
			
			var keyFrame:TransformKeyFrame = new TransformKeyFrame();
			keyFrame.time = 0;
			keyFrame.position.x = 0;
			keyFrame.scale.setTo(10, 10, 10);
			Quaternion.rotationXYZ(keyFrame.rotation, 0, 0, 0);
			track.frames.push(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 1;
			keyFrame.position.x = 100;
			keyFrame.scale.setTo(10, 100, 10);
			Quaternion.rotationXYZ(keyFrame.rotation, 0, 0, 0);
			track.frames.push(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 3;
			keyFrame.position.x = -100;
			keyFrame.scale.setTo(10, 100, 10);
			Quaternion.rotationXYZ(keyFrame.rotation, Math.PI / 4, 0, 0);
			track.frames.push(keyFrame);
			
			keyFrame = new TransformKeyFrame();
			keyFrame.time = 4;
			keyFrame.position.x = 0;
			keyFrame.scale.setTo(10, 10, 10);
			Quaternion.rotationXYZ(keyFrame.rotation, 0, 0, 0);
			track.frames.push(keyFrame);
			
			anim_controller = new AnimationController();
			anim_controller.tracks.push(track);
			anim_controller.loops = int.MAX_VALUE;
			anim_controller.calculateLength();
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