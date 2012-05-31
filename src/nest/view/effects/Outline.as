package nest.view.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	/**
	 * Outline
	 */
	public class Outline implements IEffect {
		
		private const _fragment:String = "dp3 ft1, ft5, v2\n" + 
										"slt ft1, fc17.x, ft1\n" + 
										"mul ft0, ft0, ft1\n";
		
		private const data:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var _thickness:Number;
		
		public function Outline(thickness:Number = 0.4) {
			this.thickness = thickness;
			data[1] = 0;
			data[2] = 0;
			data[3] = 0;
		}
		
		public function update(context3D:Context3D):void {
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 17, data);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get fragment():String {
			return _fragment;
		}
		
		public function get thickness():Number {
			return _thickness;
		}
		
		/**
		 * Range(0,1).
		 */
		public function set thickness(value:Number):void {
			data[0] = _thickness = value;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.effects.Outline]";
		}
	}

}