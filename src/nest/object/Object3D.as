package nest.object  
{
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	import nest.control.animation.AnimationClip;
	
	/**
	 * Object3D
	 */
	public class Object3D extends EventDispatcher implements IObject3D {
		
		public static function localToGlobal(object:Object3D, target:Vector3D):Vector3D {
			return object.worldMatrix.transformVector(target);
		}
		
		public static function globalToLocal(object:Object3D, target:Vector3D):Vector3D {
			return object.invertWorldMatrix.transformVector(target);
		}
		
		public static function translate(object:Object3D, axis:Vector3D, value:Number):Vector3D {
			var p:Vector3D = axis.clone();
			p.scaleBy(value);
			return object.worldMatrix.transformVector(p);
		}
		
		public static function lookAt(object:Object3D, target:Vector3D, upAxis:Vector3D = null):Vector3D {
			if (!upAxis) upAxis = Vector3D.Y_AXIS;
			var zAxis:Vector3D = target.subtract(object.position);
			zAxis.normalize();
			var xAxis:Vector3D = zAxis.crossProduct(upAxis);
			xAxis.normalize();
			var yAxis:Vector3D = zAxis.crossProduct(xAxis);
			yAxis.normalize();
			// TODO: 检查本地matrix是否正确
			var scale:Vector3D = object.matrix.decompose()[2];
			var rawData:Vector.<Number> = Vector.<Number>([scale.x * xAxis.x, scale.x * xAxis.y, scale.x * xAxis.z, 0,
														   scale.y * yAxis.x, scale.y * yAxis.y, scale.y * yAxis.z, 0,
														   scale.z * zAxis.x, scale.z * zAxis.y, scale.z * zAxis.z, 0,
														   object.position.x, object.position.y, object.position.z, 1]);
			var matrix:Matrix3D = new Matrix3D(rawData);
			var result:Vector3D = matrix.decompose()[2];
			if (zAxis.z < 0) {
				result.setTo(result.x - Math.PI, Math.PI - result.y , result.z - Math.PI);
			}
			return result;
		}
		
		public var name:String;
		
		protected var _orientation:String = Orientation3D.EULER_ANGLES;
		
		protected var _components:Vector.<Vector3D>;
		
		protected var _matrix:Matrix3D;
		protected var _invertMatrix:Matrix3D;
		protected var _worldMatrix:Matrix3D;
		protected var _invertWorldMatrix:Matrix3D;
		
		protected var _clips:Vector.<AnimationClip>;
		
		protected var _parent:IContainer3D;
		
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
		
		public function decompose():void {
			_components = _matrix.decompose(_orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
			if (parent) {
				_worldMatrix.copyFrom(parent.worldMatrix);
				_worldMatrix.append(_matrix);
				_invertWorldMatrix.copyFrom(_worldMatrix);
				_invertWorldMatrix.invert();
			}
		}
		
		public function recompose():void {
			_matrix.recompose(_components, _orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
			if (parent) {
				_worldMatrix.copyFrom(parent.worldMatrix);
				_worldMatrix.append(_matrix);
				_invertWorldMatrix.copyFrom(_worldMatrix);
				_invertWorldMatrix.invert();
			}
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
			recompose();
		}
		
		public function get clips():Vector.<AnimationClip> {
			return _clips;
		}
		
		public function set clips(value:Vector.<AnimationClip>):void {
			for each(var clip:AnimationClip in value) {
				if(clip) clip.target = this;
			}
			_clips = value;
		}
		
	}

}