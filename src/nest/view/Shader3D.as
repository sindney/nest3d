package nest.view 
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	/**
	 * Shader3D
	 */
	public class Shader3D {
		
		public static const assembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		private var _program:Program3D;
		private var _vertex:ByteArray;
		private var _fragment:ByteArray;
		
		private var _normal:Boolean;
		private var _changed:Boolean = false;
		
		public function Shader3D() {
			
		}
		
		public function setFromString(vertex:String, fragment:String, normal:Boolean):void {
			_changed = true;
			Shader3D.assembler.assemble(Context3DProgramType.VERTEX, vertex);
			_vertex = Shader3D.assembler.agalcode;
			Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, fragment);
			_fragment = Shader3D.assembler.agalcode;
			_normal = normal;
		}
		
		public function update(context3D:Context3D):void {
			if (!_changed) return;
			_changed = false;
			if (!_program)_program = context3D.createProgram();
			_program.upload(_vertex, _fragment);
		}
		
		public function dispose():void {
			if (_program)_program.dispose();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get normal():Boolean {
			return _normal;
		}
		
		public function get changed():Boolean {
			return _changed;
		}
		
		public function get program():Program3D {
			return _program;
		}
		
		public function get vertex():ByteArray {
			return _vertex;
		}
		
		public function set vertex(value:ByteArray):void {
			_vertex = value;
			if (value)_changed = true;
		}
		
		public function get fragment():ByteArray {
			return _fragment;
		}
		
		public function set fragment(value:ByteArray):void {
			_fragment = value;
			if (value)_changed = true;
		}
		
	}

}