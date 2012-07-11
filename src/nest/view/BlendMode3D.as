package nest.view
{
	import flash.display3D.Context3DBlendFactor;
	
	/**
	 * BlendMode3D
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
		
	}

}