package nest.object.geom 
{
	import flash.geom.Vector3D;
	
	/**
	 * Quaternion
	 */
	public final class Quaternion {
		
		private static const ONE:Number = 0.9999;
		
		/**
		 * Rotate Quaternion object to a certain angle around X axis.
		 */
		public static function rotationX(object:Vector3D, value:Number):void {
			const t2:Number = value * 0.5;
			object.w = Math.cos(t2);
			object.x = Math.sin(t2);
			object.y = 0;
			object.z = 0;
		}
		
		/**
		 * Rotate Quaternion object to a certain angle around Y axis.
		 */
		public static function rotationY(object:Vector3D, value:Number):void {
			const t2:Number = value * 0.5;
			object.w = Math.cos(t2);
			object.x = 0;
			object.y = Math.sin(t2);
			object.z = 0;
		}
		
		/**
		 * Rotate Quaternion object to a certain angle around Z axis.
		 */
		public static function rotationZ(object:Vector3D, value:Number):void {
			const t2:Number = value * 0.5;
			object.w = Math.cos(t2);
			object.x = 0;
			object.y = 0;
			object.z = Math.sin(t2);
		}
		
		/**
		 * Rotate Quaternion object to a certain angle around given axis.
		 * @param	axis Axis must be normalized.
		 */
		public static function rotate(object:Vector3D, axis:Vector3D, value:Number):void {
			const t2:Number = value * 0.5;
			const st2:Number = Math.sin(t2);
			object.w = Math.cos(t2);
			object.x = axis.x * st2;
			object.y = axis.y * st2;
			object.z = axis.z * st2;
		}
		
		public static function multiply(a:Vector3D, b:Vector3D, output:Vector3D):void {
			output.w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z;
			output.x = a.w * b.x + a.x * b.w + a.z * b.y - a.y * b.z;
			output.y = a.w * b.y + a.y * b.w + a.x * b.z - a.z * b.x;
			output.z = a.w * b.z + a.z * b.w + a.y * b.x - a.x * b.y;
		}
		
		public static function identity(object:Vector3D):void {
			object.w = 1;
			object.x = object.y = object.z = 0;
		}
		
		public static function normalize(object:Vector3D):void {
			const m:Number = Math.sqrt(object.w * object.w + object.x * object.x + object.y * object.y + object.z * object.z);
			if (m > 0) {
				const m2:Number = 1 / m;
				object.w *= m2;
				object.x *= m2;
				object.y *= m2;
				object.z *= m2;
			} else {
				identity(object);
			}
		}
		
		public static function dotProduct(a:Vector3D, b:Vector3D):Number {
			return a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z;
		}
		
		public static function slerp(a:Vector3D, b:Vector3D, t:Number, output:Vector3D):void {
			if (t <= 0) {
				output.copyFrom(a);
				return;
			}
			if (t >= 1) {
				output.copyFrom(b);
				return;
			}
			
			var cos:Number = dotProduct(a, b);
			var bw:Number = b.w;
			var bx:Number = b.x;
			var by:Number = b.y;
			var bz:Number = b.z;
			
			if (cos < 0) {
				bw = -bw;
				bx = -bx;
				by = -by;
				bz = -bz;
				cos = -cos;
			}
			
			if (cos > 1) cos = 1;
			
			var k0:Number, k1:Number;
			if (cos > ONE) {
				k0 = 1 - t;
				k1 = t;
			} else {
				const sin:Number = Math.sqrt(1 - cos * cos);
				const o:Number = Math.atan2(sin, cos);
				const sin2:Number = 1 / sin;
				k0 = Math.sin((1 - t) * o) * sin2;
				k1 = Math.sin(t * o) * sin2;
			}
			output.w = k0 * a.w + k1 * bw;
			output.x = k0 * a.x + k1 * bx;
			output.y = k0 * a.y + k1 * by;
			output.z = k0 * a.z + k1 * bz;
		}
		
		public static function conjugate(object:Vector3D, output:Vector3D):void {
			output.w = object.w;
			output.x = -object.x;
			output.y = -object.y;
			output.z = -object.z;
		}
		
		public static function pow(object:Vector3D, t:Number, output:Vector3D):void {
			if (Math.abs(object.w) > ONE) {
				output.copyFrom(object);
				return;
			}
			const a:Number = Math.acos(object.w);
			const a2:Number = a * t;
			const m:Number = Math.sin(a2) / Math.sin(a);
			output.w = Math.cos(a2);
			output.x = object.x * m;
			output.y = object.y * m;
			output.y = object.z * m;
		}
		
		public static function getAxis(object:Vector3D, axis:Vector3D):void {
			const t:Number = 1 - object.w * object.w;
			if (t <= 0) {
				axis.setTo(1, 0, 0);
				return;
			}
			const t2:Number = 1 / Math.sqrt(t);
			axis.setTo(object.x * t2, object.y * t2, object.z * t2);
		}
		
		public static function getAngle(object:Vector3D):Number {
			return Math.acos(object.w) * 2;
		}
		
	}

}