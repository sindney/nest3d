package nest.view
{
	import flash.display3D.Context3DBlendFactor;
	
	/**
	 * BlendMode3D
	 * <p>Qpaque: Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO, false</p>
	 * <p>Transparent: Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA, true</p>
	 * 
	 * @see flash.display3D.Context3DBlendFactor
	 */
	public class BlendMode3D {
		
		public var source:String;
		public var dest:String;
		public var depthMask:Boolean;
		
		public function BlendMode3D(source:String = Context3DBlendFactor.ONE, dest:String = Context3DBlendFactor.ZERO, depthMask:Boolean = true) {
			this.source = source;
			this.dest = dest;
			this.depthMask = depthMask;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.BlendMode3D]";
		}
		
	}

}