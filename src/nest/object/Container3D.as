package nest.object 
{
	
	/**
	 * Container3D
	 */
	public class Container3D extends Object3D implements IContainer3D {

		protected var _visible:Boolean = true;
		protected var _mouseEnabled:Boolean = false;
		
		protected var _numChildren:int = 0;
		
		protected var _objects:Vector.<IObject3D>;
		
		public function Container3D() {
			super();
			_objects = new Vector.<IObject3D>();
		}
		
		public function addChild(object:IObject3D):void {
			_numChildren++;
			object.parent = this;
			_objects.push(object);
		}
		
		public function removeChild(object:IObject3D):void {
			var index:int = _objects.indexOf(object);
			if (index != -1) {
				_numChildren--;
				object.parent = null;
				_objects.splice(index, 1);
			}
		}
		
		public function removeChildAt(index:int):IObject3D {
			var object:IObject3D = _objects[index];
			if (object) {
				_numChildren--;
				object.parent = null;
				_objects.splice(index, 1);
			}
			return object;
		}
		
		public function getChildAt(index:int):IObject3D {
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
		
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void {
			_mouseEnabled = value;
		}
		
	}

}