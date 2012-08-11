package nest.object 
{
	import flash.geom.Matrix3D;
	
	/**
	 * Container3D
	 */
	public class Container3D extends Object3D implements IContainer3D {
		
		protected var _invertMatrix:Matrix3D;

		protected var _visible:Boolean = true;
		
		protected var _numChildren:int = 0;
		
		protected var _objects:Vector.<IObject3D>;
		
		public function Container3D() {
			super();
			_invertMatrix = new Matrix3D();
			_objects = new Vector.<IObject3D>();
		}
		
		public function addChild(object:IObject3D):void {
			_numChildren++;
			_objects.push(object);
		}
		
		public function removeChild(object:IObject3D):void {
			var index:int = _objects.indexOf(object);
			if (index != -1) {
				_numChildren--;
				_objects.splice(index, 1);
			}
		}
		
		public function removeChildAt(index:int):IObject3D {
			var object:IObject3D = _objects[index];
			if (object) {
				_numChildren--;
				_objects.splice(index, 1);
			}
			return object;
		}
		
		public function getChildAt(index:int):IObject3D {
			return index < _numChildren ? _objects[index] : null;
		}
		
		override public function decompose():void {
			_components = _matrix.decompose(_orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
			_changed = false;
		}
		
		override public function recompose():void {
			_matrix.recompose(_components, _orientation);
			_invertMatrix.copyFrom(_matrix);
			_invertMatrix.invert();
			_changed = false;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get invertMatrix():Matrix3D {
			return _invertMatrix;
		}
		
		public function get visible():Boolean {
			return _visible;
		}
		
		public function set visible(value:Boolean):void {
			_visible = value;
		}
		
		public function get numChildren():int {
			return _numChildren;
		}
		
	}

}