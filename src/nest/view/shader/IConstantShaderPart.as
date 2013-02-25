package nest.view.shader 
{
	
	/**
	 * IConstantShaderPart
	 */
	public interface IConstantShaderPart {
		
		function get programType():String;
		function set programType(value:String):void;
		
		function get firstRegister():int;
		function set firstRegister(value:int):void;
		
		function get name():String;
		function set name(value:String):void;
		
	}
	
}