package nest.control.animation 
{
	import flash.display3D.textures.TextureBase;
	
	/**
	 * TextureKeyFrame
	 */
	public class TextureKeyFrame implements IKeyFrame {
		
		private var _time:Number;
		private var _name:String;
		
		public var data:TextureBase;
		
		public function clone():IKeyFrame {
			var result:TextureKeyFrame = new TextureKeyFrame();
			result.time = _time;
			result.name = _name;
			result.data = data;
			return result;
		}
		
		public function dispose():void {
			if (data) data.dispose();
			data = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(value:Number):void {
			_time = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
	}

}