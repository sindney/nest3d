package  
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.parser.Parser3DS;
	import nest.control.util.Primitives;
	import nest.control.util.RayIntersection;
	import nest.control.util.RayIntersectionResult;
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
		private var box:Mesh;
		private var skybox:Mesh;
		
		private var cameraPos:VectorShaderPart;
		private var lights:VectorShaderPart;
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			///////////////////////////////////
			// HEAD
			///////////////////////////////////
			
			var parser:Parser3DS = new Parser3DS();
			parser.parse(new model());
			
			mesh = parser.objects[0];
			mesh.scale.setTo(30, 30, 30);
			container.addChild(mesh);
			
			parser.dispose();
			
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendRotation(180, Vector3D.Y_AXIS);
			Geometry.setupGeometry(mesh.geometry, true, true, true, true);
			Geometry.calculateNormal(mesh.geometry);
			Geometry.calculateTangent(mesh.geometry);
			Geometry.transformGeometry(mesh.geometry, matrix);
			Geometry.uploadGeometry(mesh.geometry, true, true, true, true, true);
			Bound.calculate(mesh.bound, mesh.geometry);
			
			var diffuse:TextureResource = new TextureResource(0, null);
			TextureResource.uploadToTexture(diffuse, new bitmap_diffuse().bitmapData, false);
			var specular:TextureResource = new TextureResource(1, null);
			TextureResource.uploadToTexture(specular, new bitmap_specular().bitmapData, false);
			var normalmap:TextureResource = new TextureResource(2, null);
			TextureResource.uploadToTexture(normalmap, new bitmap_normalmap().bitmapData, false);
			
			var shader:Shader3D = new Shader3D();
			shader.constantsPart.push(new MatrixShaderPart(Context3DProgramType.VERTEX, 8, mesh.invertWorldMatrix, true));
			cameraPos = new VectorShaderPart(Context3DProgramType.VERTEX, 12, Vector.<Number>([0, 0, -400, 1]));
			shader.constantsPart.push(cameraPos);
			// ambient light color, directional light color, directional light direction
			lights = new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1]), 3);
			shader.constantsPart.push(lights);
			// glossiness
			shader.constantsPart.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([20, 1, 1, 1])));
			shader.texturesPart.push(diffuse, specular, normalmap);
			shader.comply(vertexShader(), fragmentShader());
			
			mesh.shaders.push(shader);
			
			///////////////////////////////////
			// Box
			///////////////////////////////////
			
			var box_shader:Shader3D = new Shader3D();
			box_shader.constantsPart.push(new VectorShaderPart(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 0, 0, 1])));
			box_shader.comply("m44 vt0, va0, vc0\nm44 op, vt0, vc4\n", "mov oc, fc0\n");
			
			box = new Mesh(Primitives.createBox());
			Geometry.setupGeometry(box.geometry, true, false, false, false);
			Geometry.uploadGeometry(box.geometry, true, false, false, false, true);
			Bound.calculate(box.bound, box.geometry);
			box.shaders.push(box_shader);
			box.position.x = 500;
			box.scale.setTo(10, 10, 10);
			container.addChild(box);
			
			///////////////////////////////////
			// SKYBOX
			///////////////////////////////////
			
			var cubicmap:Vector.<BitmapData> = new Vector.<BitmapData>();
			cubicmap[0] = new right().bitmapData;
			cubicmap[1] = new left().bitmapData;
			cubicmap[2] = new top().bitmapData;
			cubicmap[3] = new bottom().bitmapData;
			cubicmap[4] = new front().bitmapData;
			cubicmap[5] = new back().bitmapData;
			
			var skybox_resource:TextureResource = new TextureResource(0, null);
			TextureResource.uploadToCubeTexture(skybox_resource, cubicmap);
			
			var skybox_shader:Shader3D = new Shader3D();
			skybox_shader.texturesPart.push(skybox_resource);
			skybox_shader.comply("m44 vt0, va0, vc0\nm44 op, vt0, vc4\nmov v0, va0\n", 
								"tex oc, v0, fs0 <cube,linear,miplinear>\n");
			
			skybox = new Mesh(Primitives.createSkybox());
			Geometry.setupGeometry(skybox.geometry, true, false, false, false);
			Geometry.uploadGeometry(skybox.geometry, true, false, false, false, true);
			Bound.calculate(skybox.bound, skybox.geometry);
			skybox.shaders.push(skybox_shader);
			skybox.cliping = false;
			skybox.scale.setTo(10000, 10000, 10000);
			skybox.ignorePosition = true;
			container.addChild(skybox);
			
			camera.position.z = -400;
			camera.recompose();
		}
		
		private function vertexShader():String {
			var result:String = 
			// va0 = vertex, va3 = uv, vc0 = mesh.worldMatrix
			// vc4 = camera.invertWorldMatrix * camera.pm
			"m44 vt0, va0, vc0\n" + 
			// v0 = vertex * mesh.worldMatrix
			"mov v0, vt0\n" + 
			// v1 = uv
			"mov v1, va3\n" + 
			// v2 = normal
			"mov v2, va1\n" + 
			// project vertex
			"m44 op, vt0, vc4\n" + 
			// cameraPos
			"mov vt0, vc12.xyz\n" + 
			// cameraPos to object space
			"m44 vt0, vt0, vc8\n" + 
			// v5 = cameraDir in object space
			"nrm vt0.xyz, vt0\n" + 
			"mov v5, vt0.xyz\n" + 
			// v4 = tangent
			"mov v4, va2\n" + 
			// v3 = binormal
			"crs vt0.xyz, va1, va2\n" + 
			"mov v3, vt0\n";
			return result;
		}
		
		private function fragmentShader():String {
			var result:String = 
			// diffuse = ft7, specular = ft6, normalmap = ft5
			"tex ft7, v1, fs0 <2d,linear,mipnone>\n" + 
			"tex ft6, v1, fs1 <2d,linear,mipnone>\n" + 
			"tex ft5, v1, fs2 <2d,linear,mipnone>\n" + 
			"add ft5, ft5, ft5\n" + 
			"sub ft5, ft5, fc3.y\n" + 
			"mul ft0, v4, ft5.x\n" + 
			"mul ft1, v3, ft5.y\n" + 
			"add ft0, ft0, ft1\n" + 
			"mul ft1, v2, ft5.z\n" + 
			"add ft5, ft0, ft1\n" + 
			// ambient light, fc0 = color
			"mul ft0, ft7, fc0\n" + 
			// directional light, fc1 = color, fc2 = direction
			"mov ft2, fc2\n" + 
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
			var camPos:Vector3D = camera.worldMatrix.transformVector(new Vector3D());
			var orgion:Vector3D = mesh.invertWorldMatrix.transformVector(camPos);
			var delta:Vector3D = mesh.invertWorldMatrix.transformVector(camera.worldMatrix.transformVector(new Vector3D(0, 0, 1000)));
			var results:Vector.<RayIntersectionResult> = new Vector.<RayIntersectionResult>();
			RayIntersection.RayMesh(null, results, orgion, delta, mesh);
			var tmp0:RayIntersectionResult, tmp1:RayIntersectionResult;
			var flag:Number = Number.MAX_VALUE;
			for each(tmp0 in results) {
				if (Vector3D.distance(camPos, mesh.worldMatrix.transformVector(tmp0.point)) < flag) tmp1 = tmp0;
			}
			if (tmp1) {
				tmp1.point.copyFrom(mesh.worldMatrix.transformVector(tmp1.point));
				box.position.copyFrom(tmp1.point);
				box.recompose();
				box.visible = true;
				view.diagram.message.text = "Flag: " + tmp1.flag.toString() + "\nPoint: " + tmp1.point.toString() + "\nIndex: " + tmp1.index.toString();
			} else {
				box.visible = false;
				view.diagram.message.text = "Flag: false";
			}
			orgion.normalize();
			orgion.negate();
			lights.data[8] = orgion.x;
			lights.data[9] = orgion.y;
			lights.data[10] = orgion.z;
			cameraPos.data[0] = camPos.x;
			cameraPos.data[1] = camPos.y;
			cameraPos.data[2] = camPos.z;
		}
	}

}