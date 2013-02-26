package  
{
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	
	import nest.control.util.Primitives;
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.process.*;
	import nest.view.shader.Shader3D;
	import nest.view.shader.VectorShaderPart;
	import nest.view.Camera3D;
	import nest.view.TextureResource;
	import nest.view.ViewPort;
	
	/**
	 * RenderToTexture
	 */
	public class RenderToTexture extends DemoBase {
		
		private var process0:ContainerProcess;
		private var process1:ContainerProcess;
		
		public function RenderToTexture() {
			
		}
		
		override public function init():void {
			var container0:Container3D = new Container3D();
			var container1:Container3D = new Container3D();
			
			var camera1:Camera3D = new Camera3D();
			
			process0 = new ContainerProcess(camera1, container0);
			process0.color = 0xff000000;
			
			process1 = new ContainerProcess(camera, container1);
			process1.color = 0xffffffff;
			
			view.processes.push(process0, process1);
			
			var shader0:Shader3D = new Shader3D();
			shader0.constantParts.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 0, 0, 1])));
			shader0.comply("m44 vt0, va0, vc0\nm44 vt0, vt0, vc4\n" + 
							"m44 op, vt0, vc8\n",
							"mov oc, fc0\n");
			
			mesh = new Mesh(Primitives.createBox(), null, shader0);
			Geometry.setupGeometry(mesh.geom, true, false, false);
			Geometry.uploadGeometry(mesh.geom, true, false, false, true);
			Bound.calculate(mesh.bound, mesh.geom);
			mesh.position.z = 400;
			mesh.scale.setTo(100, 100, 100);
			container0.addChild(mesh);
			
			var material:TextureResource = new TextureResource(0, null);
			material.texture = ViewPort.context3d.createTexture(512, 512, Context3DTextureFormat.BGRA, true);
			
			var shader1:Shader3D = new Shader3D();
			shader1.comply("m44 vt0, va0, vc0\nm44 vt0, vt0, vc4\n" + 
							"m44 op, vt0, vc8\nmov v0, va2\n",
							"tex oc, v0, fs0 <2d,linear,mipnone>\n");
			
			var mesh1:Mesh = new Mesh(Primitives.createBox(), Vector.<TextureResource>([material]), shader1);
			Geometry.setupGeometry(mesh1.geom, true, false, true);
			Geometry.uploadGeometry(mesh1.geom, true, false, true, true);
			Bound.calculate(mesh1.bound, mesh1.geom);
			mesh1.rotation.x = Math.PI * 1.5;
			mesh1.position.z = 200;
			mesh1.scale.setTo(100, 100, 100);
			container1.addChild(mesh1);
			
			process0.renderTarget.texture = material.texture;
		}
		
		private var mesh:Mesh;
		
		override public function loop():void {
			view.diagram.message = "Objects: " + (process0.numObjects + process1.numObjects) + "/" + (process0.container.numChildren + process1.container.numChildren);
			mesh.rotation.y += 0.01;
			mesh.recompose();
		}
		
	}

}