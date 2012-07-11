package nest.object 
{
	import flash.geom.Matrix3D;
	
	/**
	 * Container3D
	 * <p>An extention of Object3D class.</p>
	 */
	public class Container3D extends Object3D implements IContainer3D {
		
		protected var _visible:Boolean = true;
		
		protected var _numChildren:int = 0;
		
		protected var _objects:Vector.<IPlaceable>;
		
		public function Container3D() {
			super();
			_objects = new Vector.<IPlaceable>();
		}
		
		public function addChild(object:IPlaceable):void {
			_numChildren++;
			_objects.push(object);
		}
		
		public function removeChild(object:IPlaceable):void {
			var index:int = _objects.indexOf(object);
			if (index != -1) {
				_numChildren--;
				_objects.splice(index, 1);
			}
		}
		
		public function removeChildAt(index:int):IPlaceable {
			var object:IPlaceable = _objects[index];
			if (object) {
				_numChildren--;
				_objects.splice(index, 1);
			}
			return object;
		}
		
		public function getChildAt(index:int):IPlaceable {
			return index < _numChildren ? _objects[index] : null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
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