package  
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProgramType;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	
	import nest.control.util.Primitives;
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.object.Container3D;
	import nest.object.Mesh;
	import nest.view.process.DepthMapProcess;
	import nest.view.process.IRenderProcess;
	import nest.view.shader.*;
	import nest.view.Camera3D;
	import nest.view.TextureResource;
	import nest.view.ViewPort;
	
	/**
	 * DepthMapping
	 */
	public class DepthMapping extends Sprite {
		
		protected var stage3d:Stage3D;
		
		protected var view:ViewPort;
		
		public function DepthMapping() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			stage3d = stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			stage3d.requestContext3D();
		}
		
		private function onContext3DCreated(e:Event):void {
			stage3d.removeEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			
			view = new ViewPort(stage3d.context3D, new Vector.<IRenderProcess>());
			view.configure(stage.stageWidth, stage.stageHeight);
			
			var depthMap:DepthMapProcess = new DepthMapProcess();
			perspectiveProjection(depthMap.pm);
			depthMap.container = new Container3D();
			depthMap.container.castShadows = true;
			
			var geom:Geometry = Primitives.createBox();
			Geometry.setupGeometry(geom, true, false, false, false);
			Geometry.uploadGeometry(geom, true, false, false, false, true);
			
			var shader:Shader3D = new Shader3D();
			shader.constantParts.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 1])));
			shader.comply("m44 vt0, va0, vc0\nm44 op, vt0, vc4\n", "mov oc, fc0\n");
			
			var geoms:Vector.<Geometry> = Vector.<Geometry>([geom]);
			var materials:Vector.<Vector.<TextureResource>> = Vector.<Vector.<TextureResource>>([null]);
			var shaders:Vector.<Shader3D> = Vector.<Shader3D>([shader]);
			var bound:Bound = new Bound();
			Bound.calculate(bound, geoms);
			
			var mesh:Mesh = new Mesh(false, geoms, materials, shaders, bound);
			mesh.position.setTo(0, 0, 50);
			mesh.scale.setTo(10, 10, 10);
			mesh.rotation.x = Math.PI / 4;
			mesh.castShadows = true;
			depthMap.container.addChild(mesh);
			
			view.processes.push(depthMap);
			view.calculate();
		}
		
		private function perspectiveProjection(pm:Matrix3D = null, fov:Number = 45 * Math.PI / 180, aspect:Number = 1, far:Number = 100, near:Number = 1):void {
			var ys:Number = 1 / Math.tan(fov / 2);
			var xs:Number = ys / aspect;
			pm.copyRawDataFrom(Vector.<Number>([
				xs, 0, 0, 0,
				0, ys, 0, 0,
				0, 0, far / (far - near), 1,
				0, 0, (near * far) / (near - far), 0
			]));
		}
		
	}

}