package nest.object  
{
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	/**
	 * Object3D
	 */
	public class Object3D extends EventDispatcher implements IObject3D {
		
		public var name:String;
		
		protected var _orientation:String = Orientation3D.EULER_ANGLES;
		
		protected var _components:Vector.<Vector3D> = new Vector.<Vector3D>(3, true);
		
		protected var _matrix:Matrix3D = new Matrix3D();
		protected var _invertMatrix:Matrix3D = new Matrix3D();
		protected var _worldMatrix:Matrix3D = new Matrix3D();
		protected var _invertWorldMatrix:Matrix3D = new Matrix3D();
		
		protected var _parent:IContainer3D;
		
		protected var _visible:Boolean = true;
		protected var _castShadows:Boolean = false;
		
		public function Object3D() {
			_components[0] = new Vector3D();
			_components[1] = new Vector3D();
			_components[2] = new Vector3D(1, 1, 1, 1);
		}
		
		public function decompose():void {
			_components = _matrix.decompose(_orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
			_worldMatrix.copyFrom(_matrix);
			if (parent) _worldMatrix.append(parent.worldMatrix);
			_invertWorldMatrix.copyFrom(_worldMatrix);
			_invertWorldMatrix.invert();
		}
		
		public function recompose():void {
			_matrix.recompose(_components, _orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
			_worldMatrix.copyFrom(_matrix);
			if (parent) _worldMatrix.append(parent.worldMatrix);
			_invertWorldMatrix.copyFrom(_worldMatrix);
			_invertWorldMatrix.invert();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get position():Vector3D {
			return _components[0];
		}
		
		public function get rotation():Vector3D {
			return _components[1];
		}
		
		public function get scale():Vector3D {
			return _components[2];
		}
		
		/**
		 * Call decompose() after you changed this matrix.
		 */
		public function get matrix():Matrix3D {
			return _matrix;
		}
		
		/**
		 * Do not change this, use matrix instead.
		 */
		public function get invertMatrix():Matrix3D {
			return _invertMatrix;
		}
		
		/**
		 * Do not change this, use matrix instead.
		 */
		public function get worldMatrix():Matrix3D {
			return _worldMatrix;
		}
		
		/**
		 * Do not change this, use matrix instead.
		 */
		public function get invertWorldMatrix():Matrix3D {
			return _invertWorldMatrix;
		}
		
		public function get orientation():String {
			return _orientation;
		}
		
		public function set orientation(value:String):void {
			_orientation = value;
		}
		
		public function get parent():IContainer3D {
			return _parent;
		}
		
		public function set parent(value:IContainer3D):void {
			_parent = value;
		}
		
		public function get visible():Boolean {
			return _visible;
		}
		
		public function set visible(value:Boolean):void {
			_visible = value;
		}
		
		public function get castShadows():Boolean {
			return _castShadows;
		}
		
		public function set castShadows(value:Boolean):void {
			_castShadows = value;
		}
		
	}

}