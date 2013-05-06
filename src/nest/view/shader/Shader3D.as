package nest.view.shader 
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	
	import nest.view.TextureResource;
	import nest.view.ViewPort;
	
	/**
	 * Shader3D
	 * <p>vc0-3: worldMatrix</p>
	 * <p>vc4-7: projectionMatrix</p>
	 * <p>va0: vertexBuffer</p>
	 * <p>va1: normalBuffer</p>
	 * <p>va2: tangentBuffer</p>
	 * <p>va3: uvBuffer</p>
	 */
	public class Shader3D {
		
		public static const assembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		private var _program:Program3D;
		
		public var constantsPart:Vector.<IConstantShaderPart> = new Vector.<IConstantShaderPart>();
		public var texturesPart:Vector.<TextureResource> = new Vector.<TextureResource>();
		
		public function Shader3D() {
			_program = ViewPort.context3d.createProgram();
		}
		
		public function comply(vertex:String, fragment:String):void {
			_program.upload(
				assembler.assemble(Context3DProgramType.VERTEX, vertex), 
				assembler.assemble(Context3DProgramType.FRAGMENT, fragment)
			);
		}
		
		/**
		 * @param	all Dispose texturesPart array.
		 */
		public function dispose(all:Boolean = true):void {
			if (all) for each(var texture:TextureResource in texturesPart) texture.dispose();
			texturesPart = null;
			if(_program)_program.dispose();
			_program = null;
			constantsPart = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get program():Program3D {
			return _program;
		}
		
	}

}