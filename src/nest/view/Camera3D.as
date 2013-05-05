package nest.view 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.util.Frustum;
	import nest.object.Object3D;
	
	/**
	 * Camera3D
	 */
	public class Camera3D extends Object3D {
		
		protected var _pm:Matrix3D;
		protected var _frustum:Frustum;
		
		public var aspect:Number = 4 / 3;
		public var near:Number = 1;
		public var far:Number = 10000;
		public var fov:Number = 45 * Math.PI / 180;
		
		public function Camera3D() {
			super();
			_pm = new Matrix3D();
			_frustum = new Frustum();
			update();
		}
		
		/**
		 * Update camera's matrix.
		 */
		public function update():void {
			var ys:Number = 1.0 / Math.tan(fov / 2.0);
			var xs:Number = ys / aspect;
			
			pm.copyRawDataFrom(Vector.<Number>([
				xs, 0.0, 0.0, 0.0, 
				0.0, ys, 0.0, 0.0, 
				0.0, 0.0, far / (far - near), 1.0, 
				0.0, 0.0, (near * far) / (near - far), 0.0
			]));
			
			_frustum.create(fov, aspect, near, far);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get pm():Matrix3D {
			return _pm;
		}
		
		public function get frustum():Frustum {
			return _frustum;
		}
		
	}

}