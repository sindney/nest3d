package effect 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	
	import nest.view.process.RenderTarget;
	import nest.view.ViewPort;
	
	/**
	 * PostEffect
	 */
	public class PostEffect implements IPostEffect {
		
		protected var _renderTarget:RenderTarget = new RenderTarget();
		
		protected var vertexBuffer:VertexBuffer3D;
		protected var uvBuffer:VertexBuffer3D;
		protected var indexBuffer:IndexBuffer3D;
		
		public function PostEffect() {
			var context3d:Context3D = ViewPort.context3d;
			
			var vertexData:Vector.<Number> = Vector.<Number>([-1, 1, 0, -1, -1, 0, 1, -1, 0, 1, 1, 0]);
			var uvData:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 0]);
			var indexData:Vector.<uint> = Vector.<uint>([0, 3, 2, 2, 1, 0]);
			
			vertexBuffer = context3d.createVertexBuffer(4, 3);
			vertexBuffer.uploadFromVector(vertexData, 0, 4);
			uvBuffer = context3d.createVertexBuffer(4, 2);
			uvBuffer.uploadFromVector(uvData, 0, 4);
			indexBuffer = context3d.createIndexBuffer(6);
			indexBuffer.uploadFromVector(indexData, 0, 6);
		}
		
		public function calculate():void {
			
		}
		
		public function dispose():void {
			vertexBuffer.dispose();
			vertexBuffer = null;
			uvBuffer.dispose();
			uvBuffer = null;
			indexBuffer.dispose();
			indexBuffer = null;
			_renderTarget = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get renderTarget():RenderTarget {
			return _renderTarget;
		}
		
		public function get texture():TextureBase {
			return null;
		}
		
	}

}