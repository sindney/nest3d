package nest.view 
{
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	import nest.control.math.Frustum;
	
	/**
	 * Camera3D
	 */
	public class Camera3D extends EventDispatcher {
		
		protected var _components:Vector.<Vector3D>;
		
		protected var _matrix:Matrix3D;
		protected var _invertMatrix:Matrix3D;
		
		protected var _pm:Matrix3D;
		protected var _frustum:Frustum;
		
		public var orientation:String = Orientation3D.EULER_ANGLES;
		
		public var aspect:Number = 4 / 3;
		public var near:Number = 0.1;
		public var far:Number = 10000;
		public var fov:Number = 45 * Math.PI / 180;
		
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
		
		public function decompose():void {
			_components = _matrix.decompose(orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
		}
		
		public function recompose():void {
			_matrix.recompose(_components, orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
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
		
	}

}