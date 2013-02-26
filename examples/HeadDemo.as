package  
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Vector3D;
	
	import nest.control.parser.Parser3DS;
	import nest.control.util.Primitives;
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.process.*;
	import nest.view.shader.*;
	import nest.view.TextureResource;
	import nest.view.ViewPort;
	
	/**
	 * HeadDemo
	 */
	public class HeadDemo extends DemoBase {
		
		[Embed(source = "assets/head.3ds", mimeType = "application/octet-stream")]
		private const model:Class;
		
		[Embed(source = "assets/head_diffuse.jpg")]
		private const bitmap_diffuse:Class;
		
		[Embed(source = "assets/head_specular.jpg")]
		private const bitmap_specular:Class;
		
		[Embed(source = "assets/head_normals.jpg")]
		private const bitmap_normalmap:Class;
		
		[Embed(source = "assets/skybox_top.jpg")]
		private const top:Class;
		
		[Embed(source = "assets/skybox_bottom.jpg")]
		private const bottom:Class;
		
		[Embed(source = "assets/skybox_right.jpg")]
		private const right:Class;
		
		[Embed(source = "assets/skybox_left.jpg")]
		private const left:Class;
		
		[Embed(source = "assets/skybox_front.jpg")]
		private const front:Class;
		
		[Embed(source = "assets/skybox_back.jpg")]
		private const back:Class;
		
		private var container:Container3D;
		private var process0:ContainerProcess;
		
		private var mesh:Mesh;
		private var skybox:Mesh;
		
		private var cameraPos:VectorShaderPart;
		private var lights:VectorShaderPart;
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var parser:Parser3DS = new Parser3DS();
			parser.parse(new model());
			
			mesh = parser.objects[0];
			Bound.calculate(mesh.bound, mesh.geom);
			mesh.scale.setTo(30, 30, 30);
			mesh.rotation.y = Math.PI;
			container.addChild(mesh);
			
			parser.dispose();
			
			Geometry.setupGeometry(mesh.geom, true, true, true);
			Geometry.uploadGeometry(mesh.geom, true, true, true, true);
			
			mesh.material = new Vector.<TextureResource>();
			var diffuse:TextureResource = new TextureResource(0, null);
			TextureResource.uploadToTexture(diffuse, new bitmap_diffuse().bitmapData, false);
			var specular:TextureResource = new TextureResource(1, null);
			TextureResource.uploadToTexture(specular, new bitmap_specular().bitmapData, false);
			var normalmap:TextureResource = new TextureResource(2, null);
			TextureResource.uploadToTexture(normalmap, new bitmap_normalmap().bitmapData, false);
			mesh.material.push(diffuse, specular, normalmap);
			
			mesh.shader = new Shader3D();
			
			mesh.shader.constantParts.push(new MatrixShaderPart(Context3DProgramType.VERTEX, 12, mesh.invertWorldMatrix, true));
			mesh.shader.constantParts.push(new MatrixShaderPart(Context3DProgramType.VERTEX, 16, mesh.invertMatrix, true));
			cameraPos = new VectorShaderPart(Context3DProgramType.VERTEX, 20, Vector.<Number>([0, 0, -400, 1, 1, 0, 0, 0]), 2);
			mesh.shader.constantParts.push(cameraPos);
			
			// ambient light color, directional light color, directional light direction
			lights = new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1]), 3);
			mesh.shader.constantParts.push(lights);
			// glossiness
			mesh.shader.constantParts.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([20, 1, 1, 1])));
			
			mesh.shader.comply(vertexShader(), fragmentShader());
			
			var cubicmap:Vector.<BitmapData> = new Vector.<BitmapData>();
			cubicmap[0] = new right().bitmapData;
			cubicmap[1] = new left().bitmapData;
			cubicmap[2] = new top().bitmapData;
			cubicmap[3] = new bottom().bitmapData;
			cubicmap[4] = new front().bitmapData;
			cubicmap[5] = new back().bitmapData;
			
			var skybox_material:Vector.<TextureResource> = new Vector.<TextureResource>();
			var skybox_resource:TextureResource = new TextureResource(0, null);
			TextureResource.uploadToCubeTexture(skybox_resource, cubicmap);
			skybox_material.push(skybox_resource);
			
			var shader:Shader3D = new Shader3D();
			shader.comply("m44 vt0, va0, vc0\nm44 vt0, vt0, vc4\n" + 
							"m44 op, vt0, vc8\nmov v0, va0\n", 
							"tex oc, v0, fs0 <cube,linear,miplinear>\n");
			
			skybox = new Mesh(Primitives.createSkybox(), skybox_material, shader);
			Geometry.setupGeometry(skybox.geom, true, false, false);
			Geometry.uploadGeometry(skybox.geom, true, false, false, true);
			Bound.calculate(skybox.bound, skybox.geom);
			skybox.cliping = false;
			skybox.scale.setTo(10000, 10000, 10000);
			skybox.ignorePosition = true;
			container.addChild(skybox);
			
			camera.position.z = -400;
			camera.recompose();
		}
		
		private function vertexShader():String {
			var result:String = // va0 = vertex, va2 = uv, vc0 = mesh.matrix
			// vc4 = mesh.worldMatrix, vc8 = camera.invertMatrix * camera.pm
			"m44 vt0, va0, vc0\n" + 
			// v0 = vertex * mesh.matrix
			"mov v0, vt0\n" + 
			// v1 = normal
			"mov v1, va1\n" + 
			// v2 = uv
			"mov v2, va2\n" + 
			// project vertex
			"m44 vt0, vt0, vc4\n" + 
			"m44 op, vt0, vc8\n" + 
			// cameraPos
			"mov vt0, vc20.xyz\n" + 
			// cameraPos to object space
			"m44 vt0, vt0, vc12\n" + 
			"m44 vt0, vt0, vc16\n" + 
			// v5 = cameraDir in object space
			"nrm vt0.xyz, vt0\n" + 
			"mov v5, vt0.xyz\n" + 
			// normalmap part
			"mov vt0, vc21.y\n" + 
			"mov vt0.z, vc21.x\n" + 
			"crs vt1.xyz, va1, vt0\n" + 
			"mov vt1.w, vc21.x\n" + 
			"mov vt0, vc21.y\n" + 
			"mov vt0.y, vc21.x\n" + 
			"crs vt0.xyz, va1, vt0\n" + 
			// vt0 = (vt1.length > vt0.length ? vt1 : vt0);
			"dp3 vt3, vt1, vt1\n" + 
			"dp3 vt4, vt0, vt0\n" + 
			"slt vt5, vt4, vt3\n" + 
			"mul vt1, vt1, vt5\n" + 
			"slt vt5, vt3, vt4\n" + 
			"mul vt0, vt0, vt5\n" + 
			"add vt0, vt0, vt1\n" + 
			// v4 = tangent
			"nrm vt5.xyz, vt0\n" + 
			"mov v4, vt5\n" + 
			// v3 = binormal
			"crs vt6.xyz, va2, vt0\n" + 
			"mov vt6.w, vc21.x\n" + 
			"mov v3, vt6\n";
			return result;
		}
		
		private function fragmentShader():String {
			var result:String = // diffuse = ft7, specular = ft6, normalmap = ft5
			"tex ft7, v2, fs0 <2d,linear,mipnone>\n" + 
			"tex ft6, v2, fs1 <2d,linear,mipnone>\n" + 
			"tex ft5, v2, fs2 <2d,linear,mipnone>\n" + 
			"add ft5, ft5, ft5\n" + 
			"sub ft5, ft5, fc3.y\n" + 
			"mul ft0, v4, ft5.x\n" + 
			"mul ft1, v3, ft5.y\n" + 
			"add ft0, ft0, ft1\n" + 
			"mul ft1, v1, ft5.z\n" + 
			"add ft5, ft0, ft1\n" + 
			// ambient light, fc0 = color
			"mul ft0, ft7, fc0\n" + 
			// directional light, fc1 = color, fc2 = direction
			"mov ft2, fc2\n" + 
			//"m44 ft2, ft2, fc4\n" + 
			"nrm ft2.xyz, ft2\n" + 
			"neg ft2, ft2\n" + 
			"dp3 ft4, ft2, ft5\n" + 
			"sat ft1, ft4\n" + 
			"mul ft1, ft1, ft7\n" + 
			"mul ft1, ft1, fc1\n" + 
			"add ft0, ft0, ft1\n" + 
			// specular
			"add ft1, ft2, v5\n" + 
			"dp3 ft3, ft1, ft1\n" + 
			"sqt ft3, ft3\n" + 
			"div ft1, ft1, ft3\n" + 
			"dp3 ft1, ft1, ft5\n" + 
			"pow ft1, ft1, fc3.x\n" + 
			"mul ft1, ft1, ft4\n" + 
			"sat ft1, ft1\n" + 
			"mul ft1, ft1, ft6\n" + 
			"mul ft1, ft1, fc1\n" + 
			"add ft0, ft0, ft1\n" + 
			"mov oc, ft0\n";
			return result;
		}
		
		override public function loop():void {
			var dir:Vector3D = mesh.invertWorldMatrix.transformVector(mesh.invertMatrix.transformVector(camera.position));
			dir.normalize();
			dir.negate();
			lights.data[8] = dir.x;
			lights.data[9] = dir.y;
			lights.data[10] = dir.z;
			cameraPos.data[0] = camera.position.x;
			cameraPos.data[1] = camera.position.y;
			cameraPos.data[2] = camera.position.z;
			view.diagram.message = "Objects: " + process0.numObjects + "/" + process0.container.numChildren + 
									"\nVertices: " + process0.numVertices + 
									"\nTriangles: " + process0.numTriangles;
		}
	}

}