package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.VertexBuffer3D;
	
	import nest.view.ViewPort;
	
	/**
	 * EffectProcess
	 */
	public class EffectProcess implements IEffectProcess {
		
		protected var _renderTarget:RenderTarget;
		
		protected var _textures:Vector.<TextureBase>;
		
		protected var _enableDepthAndStencil:Boolean = true;
		protected var _antiAlias:int = 0;
		
		protected var vertexBuffer:VertexBuffer3D;
		protected var uvBuffer:VertexBuffer3D;
		protected var indexBuffer:IndexBuffer3D;
		
		protected var width:Number = 0;
		protected var height:Number = 0;
		
		public function EffectProcess() {
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
			
			_renderTarget = new RenderTarget();
		}
		
		public function calculate():void {
			
		}
		
		public function comply():void {
			
		}
		
		public function resize(width:Number, height:Number):void {
			if (this.width != width || this.height != height) {
				var i:int, j:int = _textures.length;
				var texture:TextureBase;
				for (i = 0; i < j; i++) {
					texture = _textures[i];
					if (texture) texture.dispose();
					_textures[i] = ViewPort.context3d.createTexture(width, height, Context3DTextureFormat.BGRA, true);
				}
				this.width = width;
				this.height = height;
			}
		}
		
		public function dispose():void {
			var i:int, j:int = _textures.length;
			for (i = 0; i < j; i++) {
				if (_textures[i])_textures[i].dispose();
			}
			_textures = null;
			_renderTarget = null;
			vertexBuffer.dispose();
			uvBuffer.dispose();
			indexBuffer.dispose();
			vertexBuffer = null;
			uvBuffer = null;
			indexBuffer = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get textures():Vector.<TextureBase> {
			return _textures;
		}
		
		public function get texture():TextureBase {
			return _textures[0];
		}
		
		public function get enableDepthAndStencil():Boolean {
			return _enableDepthAndStencil;
		}
		
		public function set enableDepthAndStencil(value:Boolean):void {
			_enableDepthAndStencil = value;
		}
		
		public function get antiAlias():int {
			return _antiAlias;
		}
		
		public function set antiAlias(value:int):void {
			_antiAlias = value;
		}
		
		public function get renderTarget():RenderTarget {
			return _renderTarget;
		}
		
	}

}