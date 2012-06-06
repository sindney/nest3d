package  
{
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DBlendFactor;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.control.factories.ShaderFactory;
	import nest.object.data.MeshData;
	import nest.object.Mesh;
	import nest.view.materials.ColorMaterial;
	import nest.view.materials.TextureMaterial;
	import nest.view.Shader3D;
	
	/**
	 * BlendModeDemo
	 */
	public class BlendModeDemo extends DemoBase {
		
		[Embed(source = "assets/leaves.png")]
		private const bitmap:Class;
		
		public function BlendModeDemo() {
			super();
		}
		
		override public function init():void {
			var data:MeshData = PrimitiveFactory.createSphere(5, 32, 24);
			var material:TextureMaterial = new TextureMaterial(new bitmap().bitmapData);
			var shader:Shader3D = new Shader3D();
			ShaderFactory.create(shader, true, false, false, null, null, true);
			
			var mesh:Mesh = new Mesh(data, material, shader);
			mesh.culling = Context3DTriangleFace.NONE;
			mesh.blendMode.source = Context3DBlendFactor.SOURCE_ALPHA;
			mesh.blendMode.dest = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
			mesh.blendMode.depthMask = true;
			mesh.rotation.x = Math.PI / 2;
			mesh.changed = true;
			scene.addChild(mesh);
			
			for (var i:int = 0; i < 10; i++) {
				mesh = mesh.clone() as Mesh;
				mesh.rotation.x = Math.PI / 2;
				mesh.position.z = (i + 1) * 20;
				mesh.changed = true;
				scene.addChild(mesh);
			}
			
			shader = new Shader3D();
			ShaderFactory.create(shader, false);
			
			mesh = new Mesh(data, new ColorMaterial(), shader);
			mesh.culling = Context3DTriangleFace.NONE;
			mesh.rotation.x = Math.PI / 2;
			mesh.position.z = (i + 1) * 20;
			mesh.changed = true;
			scene.addChild(mesh);
			
			mesh = new Mesh(data, new ColorMaterial(), shader);
			mesh.culling = Context3DTriangleFace.NONE;
			mesh.rotation.x = Math.PI / 2;
			mesh.position.z = -20;
			mesh.changed = true;
			scene.addChild(mesh);
			
			camera.position.z = -60;
			camera.changed = true;
		}
		
	}

}