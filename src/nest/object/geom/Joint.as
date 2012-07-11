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
		
		public static function interpolate(time:Number, k0:KeyFrame, k1:KeyFrame, output:Vector3D):void {
			if (k0.time == time) {
				output.copyFrom(k0.component);
				return;
			} else if (k1.time == time) {
				output.copyFrom(k1.component);
				return;
			}
			
			const t:Number = (time - k0.time) / (k1.time - k0.time);
			
			if (k0.type == KeyFrame.POSITION) {
				v3Lerp(k0.component, k1.component, time, output);
			} else {
				Quaternion.slerp(k0.component, k1.component, time, output);
			}
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
		
		public var name:String;
		
		public var rotation:KeyFrame;
		public var position:KeyFrame;
		
		private var currentRot:KeyFrame;
		private var currentPos:KeyFrame;
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
			if (!position.next || !rotation.next) return;
			
			if (!currentPos) currentPos = position;
			while (currentPos) {
				if (!currentPos.next) {
					currentPos = position;
					break;
				}
				if (currentPos.next.time > time && currentPos.time < time) break;
				currentPos = currentPos.next;
			}
			interpolate(time, currentPos, currentPos.next, temp[0]);
			
			if (!currentRot) currentRot = rotation;
			while (currentRot) {
				if (!currentRot.next) {
					currentRot = rotation;
					break;
				}
				if (currentRot.next.time > time && currentRot.time < time) break;
				currentRot = currentRot.next;
			}
			interpolate(time, currentRot, currentRot.next, temp[1]);
			
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
		
	}

}