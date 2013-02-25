package  
{
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.VertexModifier;
	import nest.control.controller.AnimationController;
	import nest.control.parser.ParserMD2;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.process.*;
	import nest.view.shader.Shader3D;
	import nest.view.TextureResource;
	
	/**
	 * Anim_Vertex
	 */
	public class Anim_Vertex extends DemoBase {
		
		[Embed(source = "assets/marvin.jpg")]
		private const diffuse:Class;
		
		[Embed(source = "assets/marvin.md2", mimeType = "application/octet-stream")]
		private const model:Class;
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		private var anim_controller:AnimationController;
		
		public function Anim_Vertex() {
			super();
			
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new MeshProcess();
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var parser:ParserMD2 = new ParserMD2();
			parser.parse(new model(), 1);
			
			var material:Vector.<TextureResource> = new Vector.<TextureResource>();
			material.push(new TextureResource(0, null));
			TextureResource.uploadToTexture(material[0], new diffuse().bitmapData, false);
			
			var shader:Shader3D = new Shader3D();
			shader.comply("m44 vt0, va0, vc0\nm44 vt0, vt0, vc4\n" + 
							"m44 op, vt0, vc8\nmov v0, va2\n", 
							"tex oc, v0, fs0 <2d,linear,mipnone>\n");
			
			var mesh:Mesh = new Mesh(parser.geom, material, shader);
			Geometry.setupGeometry(mesh.geom, true, false, true);
			Geometry.uploadGeometry(mesh.geom, true, false, true, true);
			mesh.rotation.x = -Math.PI / 2;
			mesh.rotation.y = Math.PI / 2;
			container.addChild(mesh);
			
			var track:AnimationTrack = parser.track;
			track.modifier = new VertexModifier();
			track.target = mesh;
			track.enabled = true;
			
			parser.dispose();
			
			anim_controller = new AnimationController();
			anim_controller.tracks.push(track);
			anim_controller.loops = int.MAX_VALUE;
			anim_controller.speed = 10;
			anim_controller.setup();
			anim_controller.restart();
			
			camera.position.z = -100;
			camera.recompose();
		}
		
		override public function loop():void {
			anim_controller.calculate();
			view.diagram.message = anim_controller.time.toFixed(2);
		}
		
	}

}