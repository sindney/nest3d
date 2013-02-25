package nest.view.shader 
{
	/**
	 * VectorShaderPart
	 */
	public class VectorShaderPart implements IConstantShaderPart {
		
		private var _name:String;
		private var _programType:String;
		private var _firstRegister:int;
		
		public var numRegisters:int;
		public var data:Vector.<Number>;
		
		public function VectorShaderPart(programType:String, firstRegister:int, data:Vector.<Number>, numRegisters:int = -1) {
			_programType = programType;
			_firstRegister = firstRegister;
			this.data = data;
			this.numRegisters = numRegisters;
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