package  
{
	import nest.control.factories.*;
	import nest.object.data.MeshData;
	import nest.object.LODMesh;
	import nest.view.materials.ColorMaterial;
	import nest.view.materials.IMaterial;
	import nest.view.Shader3D;
	
	/**
	 * LODDemo
	 */
	public class LODDemo extends DemoBase {
		
		public function LODDemo() {
			super();
		}
		
		override public function init():void {
			var dataList:Vector.<MeshData> = new Vector.<MeshData>();
			var materialList:Vector.<IMaterial> = new Vector.<IMaterial>();
			var distantList:Vector.<Number> = new Vector.<Number>();
			
			var shader:Shader3D = new Shader3D(false, false);
			ShaderFactory.create(shader);
			
			dataList.push(PrimitiveFactory.createPlane(100, 100, 4, 4));
			materialList.push(new ColorMaterial(0xffffff));
			distantList.push(100);
			
			dataList.push(PrimitiveFactory.createPlane(100, 100, 2, 2));
			materialList.push(new ColorMaterial(0x666666));
			distantList.push(200);
			
			dataList.push(PrimitiveFactory.createPlane(100, 100, 1, 1));
			materialList.push(new ColorMaterial(0x333333));
			distantList.push(300);
			
			var mesh:LODMesh = new LODMesh(dataList, materialList, distantList, shader);
			scene.addChild(mesh);
			
			camera.position.y = 5;
			camera.changed = true;
		}
		
	}

}