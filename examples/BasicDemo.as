package  
{
	import nest.control.factory.PrimitiveFactory;
	import nest.control.partition.OcNode;
	import nest.control.partition.OcTree;
	import nest.object.geom.Geometry;
	import nest.object.Mesh;
	import nest.object.Container3D;
	import nest.view.effect.RadialBlur;
	import nest.view.material.ColorMaterial;
	import nest.view.process.*;
	
	/**
	 * BasicDemo
	 */
	public class BasicDemo extends DemoBase {
		
		private var process0:ContainerProcess;
		private var container:Container3D;
		
		public function BasicDemo() {
			
		}
		
		override public function init():void {
			container = new Container3D();
			
			process0 = new ContainerProcess(camera, container);
			process0.meshProcess = new BasicMeshProcess(camera);
			process0.color = 0xff000000;
			
			var effect:RadialBlur = new RadialBlur(256, 256, 1, 10);
			effect.comply();
			
			process0.renderTarget.texture = effect.texture;
			
			/**
			 * Engine's rendering process is controled by ViewPort's process array.
			 * We use ContainerProcess to draw the objects contained in container.
			 * Here, we want to add RadialBlur effect to our render pipeline, so we push it afer process0.
			 * Then we set process0's renderTarget to RadialBlur's texture, and the pipeline is:
			 * 
			 * 引擎渲染流程由view的processes数组控制，从前到后执行相应child的运算。
			 * 首先我们用ContainerProcess来对container包含的场景进行绘制操作。
			 * 这里，我们想添加RadialBlur这个效果，就将其push于process0之后。
			 * 再将process0的renderTarget设置为RadialBlur的texture，渲染流程就是：
			 * 
			 * setRenderToTexture(RadialBlur.texture);
			 * draw(container);
			 * setRenderToBackBuffer();
			 * effectShader();
			 * present();
			 */
			view.processes.push(process0, effect);
			
			var geom:Geometry = PrimitiveFactory.createBox(1, 1, 1);
			var material:ColorMaterial = new ColorMaterial();
			material.comply();
			var mesh:Mesh;
			
			var offsetX:Number = 0, offsetY:Number = 0, offsetZ:Number = 0;
			
			var i:int, j:int, k:int, l:int = 13, m:int = l * 25;
			for (i = 0; i < l; i++) {
				for (j = 0; j < l; j++) {
					for (k = 0; k < l; k++) {
						mesh = new Mesh(geom, material);
						mesh.position.setTo(i * 50 - m + offsetX, j * 50 - m + offsetY, k * 50 - m + offsetZ);
						mesh.scale.setTo(10, 10, 10);
						container.addChild(mesh);
						mesh.recompose();
					}
				}
			}
			
			// We can splite certain container with Quad or Oc tree.
			// When any of the container's mesh's transform matrix is changed, you'll need to recalculate the tree.
			// 我们可以对指定容器使用四叉八叉树进行划分，从而可以在绘制时进行高效的剔除操作。
			// 这一这些分割树都是静态的，就是说，当其中的任意Mesh有变换，就需要重新生成树以得到正确的结果。
			// 所以，您最好只在分割的容器中添加不动的Mesh。
			container.partition = new OcTree();
			(container.partition as OcTree).create(container, 4, l * 50, offsetX, offsetY, offsetZ);
			
			camera.recompose();
		}
		
		override public function loop():void {
			view.diagram.message = "Objects: " + process0.numObjects + "/" + process0.container.numChildren + 
									"\nVertices: " + process0.numVertices + 
									"\nTriangles: " + process0.numTriangles;
		}
		
	}

}