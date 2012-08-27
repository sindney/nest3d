package nest.view 
{
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	/**
	 * Camera3D
	 */
	public class Camera3D extends EventDispatcher {
		
		protected var _orientation:String = Orientation3D.EULER_ANGLES;
		
		protected var _components:Vector.<Vector3D>;
		
		protected var _matrix:Matrix3D;
		protected var _invertMatrix:Matrix3D;
		
		protected var _pm:Matrix3D;
		protected var _frustum:Frustum;
		
		protected var _aspect:Number = 4 / 3;
		protected var _near:Number = 0.1;
		protected var _far:Number = 10000;
		protected var _fov:Number = 45 * Math.PI / 180;
		
		protected var _changed:Boolean = false;
		
		public function Camera3D() {
			super();
			_components = new Vector.<Vector3D>(3, true);
			_components[0] = new Vector3D();
			_components[1] = new Vector3D();
			_components[2] = new Vector3D(1, 1, 1, 1);
			
			_matrix = new Matrix3D();
			_invertMatrix = new Matrix3D();
			
			_pm = new Matrix3D();
			_frustum = new Frustum();
			
			update();
		}
		
		public function translate(axis:Vector3D, value:Number):void {
			var p:Vector3D = axis.clone();
			p.scaleBy(value);
			_components[0] = _matrix.transformVector(p);
			_changed = true;
		}
		
		public function decompose():void {
			_components = _matrix.decompose(_orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
			_changed = false;
		}
		
		public function recompose():void {
			_matrix.recompose(_components, _orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
			_changed = false;
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
		
		public function get matrix():Matrix3D {
			return _matrix;
		}
		
		public function get invertMatrix():Matrix3D {
			return _invertMatrix;
		}
		
		public function get position():Vector3D {
			return _components[0];
		}
		
		public function get rotation():Vector3D {
			return _components[1];
		}
		
		public function get orientation():String {
			return _orientation;
		}
		
		public function set orientation(value:String):void {
			_orientation = value;
		}
		
		public function get changed():Boolean {
			return _changed;
		}
		
		public function set changed(value:Boolean):void {
			_changed = value;
		}
		
	}

}