package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	/**
	 * OcNode
	 */
	public class OcNode extends QuadNode {
		
		public function OcNode() {
			_childs = new Vector.<IPNode>(8, true);
			_vertices = new Vector.<Vector3D>(8, true);
			for (var i:int = 0; i < 8; i++) {
				_vertices[i] = new Vector3D();
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		override public function get max():Vector3D {
			return _vertices[7];
		}
		
	}

}