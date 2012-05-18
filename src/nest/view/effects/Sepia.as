package nest.view.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	/**
	 * Sepia
	 */
	public class Sepia implements IEffect {
		
		private const _fragment:String = "mul ft1.x, ft0, fc18\n" + 
										"mov ft0, ft1.x\n" + 
										"mul ft0, ft0, fc17\n";
		
		private const data:Vector.<Number> = new Vector.<Number>(4, true);
		private const data1:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function Sepia() {
			data[0] = 0.299;
			data[1] = 0.587;
			data[2] = 0.114;
			data[3] = 1;
			data1[0] = 1.2;
			data1[1] = 1.0;
			data1[2] = 0.8;
			data1[3] = 1;
		}
		
		public function update(context3D:Context3D):void {
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 18, data);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 17, data1);
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
			return "[nest.view.effects.Sepia]";
		}
	}

}