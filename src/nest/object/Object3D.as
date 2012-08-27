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
		
		protected var _components:Vector.<Vector3D>;
		
		protected var _matrix:Matrix3D;
		protected var _invertMatrix:Matrix3D;
		protected var _worldMatrix:Matrix3D;
		protected var _invertWorldMatrix:Matrix3D;
		
		protected var _parent:IContainer3D;
		
		protected var _changed:Boolean = false;
		
		public function Object3D() {
			_components = new Vector.<Vector3D>(3, true);
			_components[0] = new Vector3D();
			_components[1] = new Vector3D();
			_components[2] = new Vector3D(1, 1, 1, 1);
			
			_matrix = new Matrix3D();
			_invertMatrix = new Matrix3D();
			_worldMatrix = new Matrix3D();
			_invertWorldMatrix = new Matrix3D();
		}
		
		public function translate(axis:Vector3D, value:Number):void {
			var p:Vector3D = axis.clone();
			p.scaleBy(value);
			_components[0] = _matrix.transformVector(p);
			_changed = true;
		}
		
		public function localToGlobal(v:Vector3D):Vector3D {
			return _worldMatrix.transformVector(v);
		}
		
		public function globalToLocal(v:Vector3D):Vector3D {
			return _invertWorldMatrix.transformVector(v);
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
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get position():Vector3D {
			return _components[0];
		}
		
		public function get rotation():Vector3D {
			return _components[1];
		}
		
		public function get matrix():Matrix3D {
			return _matrix;
		}
		
		public function get invertMatrix():Matrix3D {
			return _invertMatrix;
		}
		
		public function get worldMatrix():Matrix3D {
			return _worldMatrix;
		}
		
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
		
		public function get changed():Boolean {
			return _changed;
		}
		
		public function set changed(value:Boolean):void {
			_changed = value;
		}
		
	}

}