package  
{
	import nest.control.factories.PrimitiveFactory;
	import nest.object.data.MeshData;
	import nest.object.LODMesh;
	import nest.view.materials.ColorMaterial;
	import nest.view.materials.IMaterial;
	
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
			
			dataList.push(PrimitiveFactory.createPlane(100, 100, 4, 4));
			materialList.push(new ColorMaterial(0xffffff));
			distantList.push(100);
			
			dataList.push(PrimitiveFactory.createPlane(100, 100, 2, 2));
			materialList.push(new ColorMaterial(0x666666));
			distantList.push(200);
			
			dataList.push(PrimitiveFactory.createPlane(100, 100, 1, 1));
			materialList.push(new ColorMaterial(0x333333));
			distantList.push(300);
			
			materialList[0].update();
			materialList[1].update();
			materialList[2].update();
			
			var mesh:LODMesh = new LODMesh(dataList, materialList, distantList);
			scene.addChild(mesh);
			
			camera.position.y = 5;
			camera.changed = true;
			controller.speed = 1;
		}
		
	}

}