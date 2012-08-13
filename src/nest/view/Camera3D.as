package nest.view 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.Object3D;
	
	/**
	 * Camera3D
	 */
	public class Camera3D extends Object3D {
		
		protected var _pm:Matrix3D;
		protected var _frustum:Frustum;
		
		protected var _aspect:Number = 4 / 3;
		protected var _near:Number = 0.1;
		protected var _far:Number = 10000;
		protected var _fov:Number = 45 * Math.PI / 180;
		
		public function Camera3D() {
			super();
			_pm = new Matrix3D();
			_frustum = new Frustum();
			update();
		}
		
		protected function update():void {
			const ys:Number = 1.0 / Math.tan(_fov / 2.0);
			const xs:Number = ys / _aspect;
			
			pm.copyRawDataFrom(Vector.<Number>([
				xs, 0.0, 0.0, 0.0, 
				0.0, ys, 0.0, 0.0, 
				0.0, 0.0, _far / (_far - _near), 1.0, 
				0.0, 0.0, (_near * _far) / (_near - _far), 0.0
			]));
			
			_frustum.create(_fov, _aspect, _near, _far);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get aspect():Number {
			return _aspect;
		}
		
		public function set aspect(value:Number):void {
			if (_aspect != value) {
				_aspect = value;
				update();
			}
		}
		
		public function get near():Number {
			return _near;
		}
		
		public function set near(value:Number):void {
			if (_near != value) {
				_near = value;
				update();
			}
		}
		
		public function get far():Number {
			return _far;
		}
		
		public function set far(value:Number):void {
			if (_far != value) {
				_far = value;
				update();
			}
		}
		
		public function get fov():Number {
			return _fov;
		}
		
		public function set fov(value:Number):void {
			if (_fov != value) {
				_fov = value;
				update();
			}
		}
		
		public function get pm():Matrix3D {
			return _pm;
		}
		
		public function get frustum():Frustum {
			return _frustum;
		}
		
	}

}