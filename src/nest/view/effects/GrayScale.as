package nest.view.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	/**
	 * GrayScale
	 */
	public class GrayScale implements IEffect {
		
		private const _fragment:String = "mul ft1.x, ft0, fc18\n" + 
										"mov ft0, ft1.x\n";
		
		private const data:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function GrayScale() {
			data[0] = 0.299;
			data[1] = 0.587;
			data[2] = 0.114;
			data[3] = 0;
		}
		
		public function update(context3D:Context3D):void {
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 18, data);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get fragment():String {
			return _fragment;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.effects.GrayScale]";
		}
	}

}