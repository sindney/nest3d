package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	
	/**
	 * RenderProcess
	 */
	public class RenderProcess implements IRenderProcess {
		
		protected var _texture:TextureBase;
		
		protected var _enableDepthAndStencil:Boolean = true;
		protected var _antiAlias:int = 0;
		
		protected var _clear:Boolean = true;
		
		public function RenderProcess() {
			
		}
		
		public function calculate(context3d:Context3D, next:IRenderProcess):void {
			
		}
		
		public function dispose():void {
			if (_texture)_texture.dispose();
			_texture = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get texture():TextureBase {
			return _texture;
		}
		
		public function set texture(value:TextureBase):void {
			_texture = value;
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
		
		public function get clear():Boolean {
			return _clear;
		}
		
		public function set clear(value:Boolean):void {
			_clear = value;
		}
		
	}

}