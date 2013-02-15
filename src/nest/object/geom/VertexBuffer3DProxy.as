package nest.object.geom
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;

	public class VertexBuffer3DProxy {
		
		public var name:String;
		public var buffer:VertexBuffer3D;
		public var index:int;
		public var bufferOffset:int = 0;
		public var format:String = Context3DVertexBufferFormat.FLOAT_4;
		
	}
}