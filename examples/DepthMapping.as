package  
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.util.Primitives;
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.object.Container3D;
	import nest.object.Mesh;
	import nest.view.process.ContainerProcess;
	import nest.view.process.DepthMapProcess;
	import nest.view.shader.*;
	import nest.view.Camera3D;
	import nest.view.TextureResource;
	import nest.view.ViewPort;
	
	/**
	 * DepthMapping
	 */
	public class DepthMapping extends DemoBase {
		
		private var process0:DepthMapProcess;
		private var process1:ContainerProcess;
		private var container:Container3D;
		private var lightPM:MatrixShaderPart;
		
		override public function init():void {
			container = new Container3D();
			container.castShadows = true;
			
			process0 = new DepthMapProcess(container);
			perspectiveProjection(process0.pm);
			
			process1 = new ContainerProcess(camera, container);
			process1.color = 0xff000000;
			
			view.processes.push(process0, process1);
			
			var depthMap:TextureResource = new TextureResource(0, null);
			depthMap.texture = ViewPort.context3d.createTexture(512, 512, Context3DTextureFormat.BGRA, true);
			
			process0.renderTarget.texture = depthMap.texture;
			
			lightPM = new MatrixShaderPart(Context3DProgramType.VERTEX, 8, new Matrix3D(), true);
			lightPM.matrix.copyFrom(process0.ivm);
			lightPM.matrix.append(process0.pm);
			
			var shader:Shader3D = new Shader3D();
			shader.constantParts.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1 / (255 * 255 * 255), 1 / (255 * 255), 1 / 255, 1])), 
									lightPM, new VectorShaderPart(Context3DProgramType.VERTEX, 12, Vector.<Number>([0.5, 0, 0, 0])));
			shader.comply(getShadowVertexShader(), getShadowFragmentShader());
			
			var geom:Geometry = Primitives.createPlane();
			Geometry.setupGeometry(geom, true, false, false, false);
			Geometry.uploadGeometry(geom, true, false, false, false, true);
			
			var geometries:Vector.<Geometry> = Vector.<Geometry>([geom]);
			var materials:Vector.<Vector.<TextureResource>> = new Vector.<Vector.<TextureResource>>(1, true);
			materials[0] = Vector.<TextureResource>([depthMap]);
			var shaders:Vector.<Shader3D> = Vector.<Shader3D>([shader]);
			var bound:Bound = new Bound();
			Bound.calculate(bound, geometries);
			
			var mesh:Mesh = new Mesh(false, geometries, materials, shaders, bound);
			mesh.position.setTo(0, 0, 50);
			mesh.scale.setTo(10, 10, 1);
			mesh.castShadows = true;
			container.addChild(mesh);
			
			mesh = new Mesh(false, geometries, materials, shaders, bound);
			mesh.position.setTo(0, 0, 100);
			mesh.scale.setTo(50, 50, 1);
			mesh.castShadows = true;
			container.addChild(mesh);
		}
		
		// vt1 = mesh.wm
		// op = vt1 * camPM
		// vt1 = vt1 * lightPM
		private function getShadowVertexShader():String {
			return "m44 vt1, va0, vc0\nm44 op, vt1, vc4\nm44 vt1, vt1, vc8\n" + 
					"neg vt1.y, vt1.y\n" + 
					"div vt1, vt1, vt1.w\n" + 
					"mul vt1.xy, vt1.xy, vc12.x\n" + 
					"add vt1.xy, vt1.xy, vc12.x\n" + 
					"mov v0, vt1\n";
		}
		
		private function getShadowFragmentShader():String {
			return "tex ft0, v0.rg, fs0 <2d,linear,mipnone>\n" + 
					"dp4 ft1, ft0, fc0\n" + 
					"sge oc, ft1, v0.b\n";
		}
		
		private function perspectiveProjection(pm:Matrix3D = null, fov:Number = 45 * Math.PI / 180, aspect:Number = 1, far:Number = 1000, near:Number = 1):void {
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