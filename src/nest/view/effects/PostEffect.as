package nest.view.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.TextureBase;
	import flash.events.Event;
	
	import nest.control.GlobalMethods;
	
	/**
	 * PostEffect
	 */
	public class PostEffect implements IPostEffect {
		
		protected var _textures:Vector.<TextureBase>;
		protected var _next:IPostEffect;
		protected var _antiAlias:int = 0;
		
		public function PostEffect() {
			onViewResized(null);
			GlobalMethods.view.addEventListener(Event.RESIZE, onViewResized);
		}
		
		public function calculate():void {
			
		}
		
		public function dispose():void {
			var texture:TextureBase;
			for each(texture in _textures) {
				if (texture) texture.dispose();
			}
			_next = null;
		}
		
		protected function onViewResized(e:Event):void {
			var w:Number = 2;
			while (GlobalMethods.view.width > w) w *= 2;
			var h:Number = 2;
			while (GlobalMethods.view.height > h) h *= 2;
			var i:int, j:int = _textures.length;
			var texture:TextureBase;
			for (i = 0; i < j; i++) {
				texture = _textures[i];
				if (texture) texture.dispose();
				texture = GlobalMethods.context3d.createTexture(w, h, Context3DTextureFormat.BGRA, true);
				_textures[i] = texture;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get textures():Vector.<TextureBase> {
			return _textures;
		}
		
		public function get enableDepthAndStencil():Boolean {
			return true;
		}
		
		public function get antiAlias():int {
			return _antiAlias;
		}
		
		public function set antiAlias(value:int):void {
			_antiAlias = value;
		}
		
		public function get next():IPostEffect {
			return _next;
		}
		
		public function set next(value:IPostEffect):void {
			_next = value;
		}
		
	}

}