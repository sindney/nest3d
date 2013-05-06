package  
{
	import flash.display3D.Context3DProgramType;
	import flash.events.MouseEvent;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.VertexModifier;
	import nest.control.controller.AnimationController;
	import nest.control.parser.ParserMD2;
	import nest.control.util.Primitives;
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.process.*;
	import nest.view.shader.*;
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
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.color = 0xff000000;
			
			view.processes.push(process0);
			
			var parser:ParserMD2 = new ParserMD2();
			parser.parse(new model(), false, false);
			Geometry.setupGeometry(parser.geom, true, false, false, true);
			Geometry.uploadGeometry(parser.geom, true, false, false, true, true);
			
			var shader:Shader3D = new Shader3D();
			shader.texturesPart.push(new TextureResource(0, null));
			shader.comply("m44 vt0, va0, vc0\nm44 op, vt0, vc4\nmov v0, va3\n", 
							"tex oc, v0, fs0 <2d,linear,mipnone>\n");
			TextureResource.uploadToTexture(shader.texturesPart[0], new diffuse().bitmapData, false);
			
			var mesh:Mesh = new Mesh(parser.geom);
			Bound.calculate(mesh.bound, mesh.geometry);
			mesh.shaders.push(shader);
			mesh.rotation.y = Math.PI / 2;
			container.addChild(mesh);
			
			var track:AnimationTrack = parser.track;
			track.modifier = new VertexModifier();
			track.parameters[VertexModifier.VERTEX_NORMAL] = false;
			track.parameters[VertexModifier.VERTEX_TANGENT] = false;
			track.target = mesh;
			
			anim_controller = new AnimationController();
			anim_controller.tracks.push(track);
			anim_controller.loops = int.MAX_VALUE;
			anim_controller.speed = 10;
			anim_controller.setup();
			anim_controller.restart();
			
			parser.dispose();
			
			camera.position.z = -100;
			camera.recompose();
		}
		
		override protected function onRightClick(e:MouseEvent):void {
			anim_controller.paused = !anim_controller.paused;
		}
		
		override public function loop():void {
			anim_controller.calculate();
			view.diagram.message.text = anim_controller.time.toFixed(2);
		}
		
	}

}