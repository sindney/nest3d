package nest.object.geom 
{
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	import nest.object.data.KeyFrame;
	
	/**
	 * Joint
	 */
	public class Joint {
		
		public static function interpolate(time:Number, k0:KeyFrame, k1:KeyFrame, output:Vector.<Vector3D>):void {
			if (k0.time == time) {
				output[0].copyFrom(k0.components[0]);
				output[1].copyFrom(k0.components[1]);
				return;
			} else if (k1.time == time) {
				output[0].copyFrom(k1.components[0]);
				output[1].copyFrom(k1.components[1]);
				return;
			}
			
			const t:Number = (time - k0.time) / (k1.time - k0.time);
			
			v3Lerp(k0.components[0], k1.components[0], time, output[0]);
			Quaternion.slerp(k0.components[1], k1.components[1], time, output[1]);
		}
		
		public static function v3Lerp(v0:Vector3D, v1:Vector3D, time:Number, output:Vector3D):void {
			output.x = v1.x - v0.x;
			output.y = v1.y - v0.y;
			output.z = v1.z - v0.z;
			output.scaleBy(time);
			output.x = v0.x + output.x;
			output.y = v0.y + output.y;
			output.z = v0.z + output.z;
		}
		
		public var firstChild:Joint;
		public var sibling:Joint;
		
		public var keyframe:KeyFrame;
		
		private var current:KeyFrame;
		private var temp:Vector.<Vector3D>;
		
		private var _combined:Matrix3D;
		private var _local:Matrix3D;
		private var _result:Matrix3D;
		
		public function Joint() {
			temp = new Vector.<Vector3D>(3, true);
			temp[0] = new Vector3D();
			temp[1] = new Vector3D();
			temp[2] = new Vector3D(1, 1, 1);
			
			_combined = new Matrix3D();
			_local = new Matrix3D();
			_result = new Matrix3D();
		}
		
		public function update(parent:Matrix3D, time:Number):void {
			if (!keyframe.next) return;
			
			if (!current) current = keyframe;
			while (current) {
				if (!current.next) {
					current = keyframe;
					break;
				}
				if (current.next.time > time && current.time < time) break;
				current = current.next;
			}
			
			interpolate(time, current, current.next, temp);
			
			_local.recompose(temp, Orientation3D.QUATERNION);
			
			_combined.copyFrom(_local);
			_combined.append(parent);
			
			_result.copyFrom(_combined);
			_result.invert();
			
			if (sibling) sibling.update(parent, time);
			if (firstChild) firstChild.update(_combined, time);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get combined():Matrix3D {
			return _combined;
		}
		
		public function get local():Matrix3D {
			return _local;
		}
		
		public function get result():Matrix3D {
			return _result;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.object.geom.Joint]";
		}
		
	}

}