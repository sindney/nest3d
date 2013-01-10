package nest.object.geom 
{
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	import nest.control.animation.AnimationClip;
	import nest.control.animation.IKeyFrame;
	import nest.object.IMesh;
	
	/**
	 * Joint
	 */
	public class Joint {
		
		public var name:String;
		
		public var firstChild:Joint;
		public var sibling:Joint;
		
		public var mesh:IMesh;
		public var clip:AnimationClip;
		
		private var temp:Vector.<Vector3D>;
		
		private var _local:Matrix3D;
		private var _offset:Matrix3D;
		private var _combined:Matrix3D;
		
		public function Joint() {
			temp = new Vector.<Vector3D>(3, true);
			temp[0] = new Vector3D();
			temp[1] = new Vector3D();
			temp[2] = new Vector3D(1, 1, 1, 1);
			_local = new Matrix3D();
			_offset = new Matrix3D();
			_combined = new Matrix3D();
		}
		
		public function update(parent:Matrix3D, time:Number):void {
			_local.recompose(temp, Orientation3D.QUATERNION);
			
			_combined.copyFrom(parent);
			_combined.append(_offset);
			_combined.append(_local);
			
			if (sibling) sibling.update(parent, time);
			if (firstChild) firstChild.update(_combined, time);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get local():Matrix3D {
			return _local;
		}
		
		public function get offset():Matrix3D {
			return _offset;
		}
		
		public function get combined():Matrix3D {
			return _combined;
		}
		
	}

}