package nest.view.shader 
{
	import flash.utils.ByteArray;
	
	/**
	 * ByteArrayShaderPart
	 */
	public class ByteArrayShaderPart implements IConstantShaderPart {
		
		private var _name:String;
		private var _programType:String;
		private var _firstRegister:int;
		
		public var numRegisters:int;
		public var data:ByteArray
		public var byteArrayOffset:uint;
		
		public function ByteArrayShaderPart(programType:String, firstRegister:int, numRegisters:int, data:ByteArray, byteArrayOffset:uint) {
			_programType = programType;
			_firstRegister = firstRegister;
			this.data = data;
			this.numRegisters = numRegisters;
			this.byteArrayOffset = byteArrayOffset;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get programType():String {
			return _programType;
		}
		
		public function set programType(value:String):void {
			_programType = value;
		}
		
		public function get firstRegister():int {
			return _firstRegister;
		}
		
		public function set firstRegister(value:int):void {
			_firstRegister = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
	}

}