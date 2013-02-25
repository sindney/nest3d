package nest.view.shader 
{
	import flash.geom.Matrix3D;
	
	/**
	 * MatrixShaderPart
	 */
	public class MatrixShaderPart implements IConstantShaderPart {
		
		private var _name:String;
		private var _programType:String;
		private var _firstRegister:int;
		
		public var transposedMatrix:Boolean;
		public var matrix:Matrix3D;
		
		public function MatrixShaderPart(programType:String, firstRegister:int, matrix:Matrix3D, transposedMatrix:Boolean = false) {
			_programType = programType;
			_firstRegister = firstRegister;
			this.matrix = matrix;
			this.transposedMatrix = transposedMatrix;
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