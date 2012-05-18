package nest.view 
{
	/**
	 * Fog
	 */
	public class Fog {
		
		private var _color:Vector.<Number>;
		private var _data:Vector.<Number>;
		
		public function Fog(color:uint = 0xffffff, max:Number = 600, min:Number = 100) {
			_color = new Vector.<Number>(4, true);
			_data = new Vector.<Number>(4, true);
			this.max = max;
			this.min = min;
			_data[2] = 0;
			_data[3] = 0;
			setColor(color);
		}
		
		public function setColor(value:uint):void {
			_color[0] = ((value >> 16) & 0xFF) / 255;
			_color[1] = ((value >> 8) & 0xFF) / 255;
			_color[2] = (value & 0xFF) / 255;
			_color[3] = 1;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get max():Number {
			return Math.sqrt(_data[0]);
		}
		
		public function set max(value:Number):void {
			_data[0] = value * value;
		}
		
		public function get min():Number {
			return Math.sqrt(_data[1]);
		}
		
		public function set min(value:Number):void {
			_data[1] = value * value;
		}
		
		public function get color():Vector.<Number> {
			return _color;
		}
		
		public function get data():Vector.<Number> {
			return _data;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.Fog]";
		}
	}

}