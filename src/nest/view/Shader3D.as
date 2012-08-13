package nest.view 
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	/**
	 * Shader3D
	 */
	public class Shader3D {
		
		public static const assembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		public var changed:Boolean = false;
		public var normal:Boolean;
		
		public var program:Program3D;
		public var vertex:ByteArray;
		public var fragment:ByteArray;
		
		public function Shader3D() {
			
		}
		
		public function setFromString(vertex:String, fragment:String, normal:Boolean):void {
			changed = true;
			Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vertex);
			this.vertex = Shader3D.assembler.agalcode;
			Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragment);
			this.fragment = Shader3D.assembler.agalcode;
			this.normal = normal;
		}
		
	}

}